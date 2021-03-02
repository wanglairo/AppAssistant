//
//  AssistantURLProtocol.swift
//  Alamofire
//
//  Created by 王来 on 2020/10/19.
//

class AssistantURLProtocol: URLProtocol, URLSessionDataDelegate {

    private static let assistantProtocolKey = "assistant_protocol_key"

    private var urlSession: URLSession?
    private var startTime: TimeInterval?
    private var response: URLResponse?
    private var data: NSMutableData?
    private var error: NSError?

    private var clientThread: Thread?
    private var calculatedModes = [String]()
    private var assistantTask: URLSessionDataTask?

    override class func canInit(with task: URLSessionTask) -> Bool {

        if let request = task.currentRequest {
            return canInit(with: request)
        } else {
            return false
        }
    }

    override class func canInit(with request: URLRequest) -> Bool {

        if let
            hasValue = URLProtocol.property(forKey: AssistantURLProtocol.assistantProtocolKey, in: request) as? Bool, hasValue {
            return false
        }

        if !NetworkInterceptor.shareInstance.shouldIntercept() {
            return false
        }

        if request.url?.scheme != "http" && request.url?.scheme != "https" {
            return false
        }

        // 文件类型不作处理
        if let contentType = request.value(forHTTPHeaderField: "Content-Type"), contentType.contains("multipart/form-data") {
            return false
        }

        return true
    }

    override class func canonicalRequest(for request: URLRequest) -> URLRequest {

        guard let mutableRequest = (request as NSURLRequest).mutableCopy() as? NSMutableURLRequest else {
            return request
        }

        URLProtocol.setProperty(true, forKey: AssistantURLProtocol.assistantProtocolKey, in: mutableRequest)
        return mutableRequest as URLRequest
    }

    func handleFromSelect() {
        if NetworkInterceptor.shareInstance.weakDelegate?.weakNetSelecte() == AssistantWeakNetType.delay {
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) { [weak self] in
                guard let self = self else {
                    return
                }
                self.assistantTask?.resume()
            }
        } else if NetworkInterceptor.shareInstance.weakDelegate?.weakNetSelecte() == AssistantWeakNetType.speed {
//            NetworkInterceptor.shareInstance().weakDelegate.handleWeak(DoraemonUrlUtil.getHttpBodyFromRequest(self.request), isDown: false)
            self.assistantTask?.resume()
        } else {
            self.assistantTask?.resume()
        }
    }

    func needLoading() -> Bool {
        var result: Bool = true
        if let weakDelegate = NetworkInterceptor.shareInstance.weakDelegate {
            if weakDelegate.weakNetSelecte() == AssistantWeakNetType.outTime {
                client?.urlProtocol(self, didFailWithError: NSError(domain: NSCocoaErrorDomain, code: NSURLErrorTimedOut, userInfo: nil))
                result = false
            } else if NetworkInterceptor.shareInstance.weakDelegate?.weakNetSelecte() == AssistantWeakNetType.breakNet {
                client?.urlProtocol(self, didFailWithError: NSError(domain: NSCocoaErrorDomain, code: NSURLErrorNotConnectedToInternet, userInfo: nil))
                result = false
            }
        }
        return result
    }

    override func startLoading() {

        calculatedModes.append(RunLoop.Mode.default.rawValue)
        if let currentMode = RunLoop.current.currentMode, currentMode != RunLoop.Mode.default {
            calculatedModes.append(currentMode.rawValue)
        }

        self.clientThread = Thread.current
        self.data = NSMutableData()
        self.startTime = Date().timeIntervalSince1970
        self.assistantTask = AssistantURLSessionDemux.shareInstance.dataTaskWithRequest(request, delegate: self, modes: calculatedModes)
        if NetworkInterceptor.shareInstance.weakDelegate != nil {
            self.handleFromSelect()
        } else {
            self.assistantTask?.resume()
        }
    }

    override func stopLoading() {

        // swiftlint:disable line_length
        let reData = (data as Data?) ?? Data()
        NetworkInterceptor.shareInstance.handleResultWithData(reData, response: response ?? URLResponse(), request: request, error: error ?? NSError(), startTime: startTime ?? 0)
        if self.assistantTask != nil {
            self.assistantTask?.cancel()
        }
    }

    // - NSURLSessionDelegate
    // swiftlint:disable line_length
    func urlSession(_ session: URLSession, dataTask: URLSessionDataTask, didReceive response: URLResponse, completionHandler: @escaping (URLSession.ResponseDisposition) -> Void) {
        self.response = response
        if needLoading() {
            client?.urlProtocol(self, didReceive: response, cacheStoragePolicy: URLCache.StoragePolicy.notAllowed)
            completionHandler(Foundation.URLSession.ResponseDisposition.allow)
        }
    }

    func urlSession(_ session: URLSession, dataTask: URLSessionDataTask, didReceive data: Data) {

        if let weakDelegate = NetworkInterceptor.shareInstance.weakDelegate, weakDelegate.weakNetSelecte() == .speed {
            weakDelegate.handleWeak(data: data as NSData, isDown: true)
        }

        self.data?.append(data)
        self.client?.urlProtocol(self, didLoad: data)
    }

    func urlSession(_ session: URLSession, task: URLSessionTask, didCompleteWithError error: Error?) {

        if let error = error {
            self.error = error as NSError
            client?.urlProtocol(self, didFailWithError: error)
        } else if self.needLoading() {
            client?.urlProtocolDidFinishLoading(self)
        }
    }

    func urlSession(_ session: URLSession, task: URLSessionTask, didReceive challenge: URLAuthenticationChallenge, completionHandler: @escaping (URLSession.AuthChallengeDisposition, URLCredential?) -> Void) {

        // 判断服务器返回的证书类型, 是否是服务器信任
        if challenge.protectionSpace.authenticationMethod == NSURLAuthenticationMethodServerTrust {
            if let serverTrust = challenge.protectionSpace.serverTrust {
                // 强制信任
                let card = URLCredential(trust: serverTrust)
                completionHandler(URLSession.AuthChallengeDisposition.useCredential, card)
            }
        }
    }

    // 去掉一些我们不关心的链接, 与UIWebView的兼容还是要好好考略一下
    class func ignoreRequest(_ request: NSURLRequest) -> Bool {
        let pathExtension = NSString(string: request.url?.absoluteString ?? "").pathExtension
        if !pathExtension.isEmpty {
            return true
        }
        return false
    }

}
