//
//  NetworkInterceptor.swift
//  Alamofire
//
//  Created by 王来 on 2020/10/19.
//

protocol NetworkInterceptorDelegate: NSObjectProtocol {

    func shouldIntercept() -> Bool

    func networkInterceptorDidReceiveData(data: Data,
                                          response: URLResponse,
                                          request: URLRequest,
                                          error: NSError,
                                          startTime: TimeInterval)

}

protocol NetworkWeakDelegate: NSObjectProtocol {

    func weakNetSelecte() -> AssistantWeakNetType

    func delayTime() -> UInt

    func handleWeak(data: NSData, isDown: Bool)

}

enum AssistantWeakNetType {

    // - 弱网选项对应
    // 断网
    case breakNet

    // 超时
    case outTime

    // 限网
    case speed

    // 延时
    case delay
}

class NetworkInterceptor: NSObject {

    static let shareInstance = NetworkInterceptor()

    var delegates = NSHashTable<AnyObject>.weakObjects()

    weak var weakDelegate: NetworkWeakDelegate?

    func addDelegate(_ delegate: NetworkInterceptorDelegate) {
        self.delegates.add(delegate)
        self.updateURLProtocolInterceptStatus()
    }

    func removeDelegate(_ delegate: NetworkInterceptorDelegate) {
        self.delegates.remove(delegate)
        self.updateURLProtocolInterceptStatus()
    }

    func shouldIntercept() -> Bool {
        // 当有对象监听 拦截后的网络请求时，才需要拦截
        var shouldIntercept: Bool = false
        for delegate in delegates.objectEnumerator() {
            if let delegate = delegate as? NetworkInterceptorDelegate, delegate.shouldIntercept() {
                shouldIntercept = true
            }
        }
        return shouldIntercept
    }

    func updateURLProtocolInterceptStatus() {
        URLSessionConfiguration.runtimeReplaceProtocolClasses()
        if shouldIntercept() {
            URLProtocol.registerClass(AssistantURLProtocol.self)
        } else {
            URLProtocol.unregisterClass(AssistantURLProtocol.self)
        }
    }

    func updateInterceptStatusForSessionConfiguration(_ sessionConfiguration: URLSessionConfiguration) {
        // BOOL shouldIntercept = [self shouldIntercept];
        // swiftlint:disable line_length
        if sessionConfiguration.responds(to: #selector(getter: URLSessionConfiguration.protocolClasses)) && sessionConfiguration.responds(to: #selector(setter: URLSessionConfiguration.protocolClasses)) {
            var urlProtocolClasses = sessionConfiguration.protocolClasses
            let protoCls = AssistantURLProtocol.self
            if urlProtocolClasses?.contains(where: { $0 == protoCls }) != nil {
                if let firstIndex = urlProtocolClasses?.firstIndex(where: { $0 == protoCls }) {
                    urlProtocolClasses?.remove(at: firstIndex)
                }
            } else {
                urlProtocolClasses?.insert(protoCls, at: 0)
            }
            sessionConfiguration.protocolClasses = urlProtocolClasses
        }
    }

    func handleResultWithData(_ data: Data,
                              response: URLResponse,
                              request: URLRequest,
                              error: NSError,
                              startTime: TimeInterval) {

        DispatchQueue.main.async {
            for delegate in self.delegates.objectEnumerator() {
                if let delegate = delegate as? NetworkInterceptorDelegate {
                    delegate.networkInterceptorDidReceiveData(data: data, response: response, request: request, error: error, startTime: startTime)
                }
            }
        }
    }

}
