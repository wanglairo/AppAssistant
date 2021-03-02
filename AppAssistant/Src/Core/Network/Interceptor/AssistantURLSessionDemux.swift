//
//  AssistantURLSessionDemux.swift
//  Alamofire
//
//  Created by 王来 on 2020/10/19.
//

import Foundation

class AssistantURLSessionDemuxTaskInfo: NSObject {

    var task: URLSessionDataTask?
    weak var delegate: URLSessionDataDelegate?
    var thread: Thread?
    var modes: [String]?

    override init() {
        super.init()
    }

    init(_ task: URLSessionDataTask,
         delegate: URLSessionDataDelegate,
         modes: [String]) {

        self.task = task
        self.delegate = delegate
        self.thread = Thread.current
        self.modes = modes
    }

    func performBlock(block: DispatchWorkItem) {
        perform(Selector(("performBlockOnClientThread:")), on: thread ?? Thread.current, with: [block], waitUntilDone: false, modes: self.modes)
    }

    func performBlockOnClientThread(block: DispatchWorkItem) {
        block.perform()
    }

    func invalidate() {
        self.delegate = nil
        self.thread = nil
    }

}

func synchronized(_ obj: AnyObject, closure: () -> Void) {
    objc_sync_enter(obj)
    closure()
    objc_sync_exit(obj)
}

class AssistantURLSessionDemux: NSObject, URLSessionDataDelegate {

    static let shareInstance = AssistantURLSessionDemux(URLSessionConfiguration.default)

    var taskInfoByTaskID: [NSNumber: Any]?
    var sessionDelegateQueue: OperationQueue?

    var configuration: URLSessionConfiguration?
    var session: URLSession?

    override init() {
        super.init()
    }

    init(_ configuration: URLSessionConfiguration) {

        super.init()

        self.configuration = configuration
        self.taskInfoByTaskID = [NSNumber: Any]()
        self.sessionDelegateQueue = OperationQueue()
        self.sessionDelegateQueue?.maxConcurrentOperationCount = 1
        self.sessionDelegateQueue?.name = "AssistantURLSessionDemux"
        self.session = URLSession(configuration: configuration, delegate: self, delegateQueue: sessionDelegateQueue)
        self.session?.sessionDescription = "AssistantURLSessionDemux"
    }

    func dataTaskWithRequest(_ request: URLRequest,
                             delegate: URLSessionDataDelegate,
                             modes: [String]) -> URLSessionDataTask {

        var taskInfo: AssistantURLSessionDemuxTaskInfo
        var modes = modes

        if modes.isEmpty {
            modes = [RunLoop.Mode.default.rawValue]
        }

        let task = self.session?.dataTask(with: request)

        taskInfo = AssistantURLSessionDemuxTaskInfo(task ?? URLSessionDataTask.new(), delegate: delegate, modes: modes)

        synchronized(self) {
            self.taskInfoByTaskID?[NSNumber(value: task?.taskIdentifier ?? 0)] = taskInfo
        }

        return task ?? URLSessionDataTask.new()
    }

    func taskInfoForTask(_ task: URLSessionTask) -> AssistantURLSessionDemuxTaskInfo {
        var result: AssistantURLSessionDemuxTaskInfo?

        synchronized(self) {
            result = self.taskInfoByTaskID?[NSNumber(value: task.taskIdentifier)] as? AssistantURLSessionDemuxTaskInfo
        }
        return result ?? AssistantURLSessionDemuxTaskInfo()
    }

    // swiftlint:disable line_length
    func urlSession(_ session: URLSession, task: URLSessionTask, willPerformHTTPRedirection response: HTTPURLResponse, newRequest request: URLRequest, completionHandler: @escaping (URLRequest?) -> Void) {

        let taskInfo = taskInfoForTask(task)
        if taskInfo.delegate?.responds(to: #selector(urlSession(_:task:willPerformHTTPRedirection:newRequest:completionHandler:))) != nil {
            taskInfo.delegate?.urlSession?(session, task: task, willPerformHTTPRedirection: response, newRequest: request, completionHandler: completionHandler)
        } else {
            completionHandler(request)
        }
    }

    func urlSession(_ session: URLSession, task: URLSessionTask, didReceive challenge: URLAuthenticationChallenge, completionHandler: @escaping (URLSession.AuthChallengeDisposition, URLCredential?) -> Void) {

        let taskInfo = taskInfoForTask(task)
        if taskInfo.delegate?.responds(to: #selector(urlSession(_:task:didReceive:completionHandler:))) != nil {
            taskInfo.delegate?.urlSession?(session, task: task, didReceive: challenge, completionHandler: completionHandler)
        } else {
            completionHandler(URLSession.AuthChallengeDisposition.performDefaultHandling, nil)
        }
    }

    func urlSession(_ session: URLSession, task: URLSessionTask, needNewBodyStream completionHandler: @escaping (InputStream?) -> Void) {
        let taskInfo = taskInfoForTask(task)
        if taskInfo.delegate?.responds(to: #selector(urlSession(_:task:needNewBodyStream:))) != nil {
            taskInfo.delegate?.urlSession?(session, task: task, needNewBodyStream: completionHandler)
        } else {
            completionHandler(nil)
        }
    }

    func urlSession(_ session: URLSession, task: URLSessionTask, didSendBodyData bytesSent: Int64, totalBytesSent: Int64, totalBytesExpectedToSend: Int64) {

        let taskInfo = taskInfoForTask(task)
        if taskInfo.delegate?.responds(to: #selector(urlSession(_:task:didSendBodyData:totalBytesSent:totalBytesExpectedToSend:))) != nil {
            taskInfo.delegate?.urlSession?(session, task: task, didSendBodyData: bytesSent, totalBytesSent: totalBytesSent, totalBytesExpectedToSend: totalBytesExpectedToSend)
        }
    }

    func urlSession(_ session: URLSession, task: URLSessionTask, didCompleteWithError error: Error?) {
        let taskInfo = taskInfoForTask(task)
        if taskInfo.delegate?.responds(to: #selector(urlSession(_:task:didCompleteWithError:))) != nil {
            taskInfo.delegate?.urlSession?(session, task: task, didCompleteWithError: error)
            taskInfo.invalidate()
        } else {
            taskInfo.invalidate()
        }
    }

    func urlSession(_ session: URLSession, dataTask: URLSessionDataTask, didReceive response: URLResponse, completionHandler: @escaping (URLSession.ResponseDisposition) -> Void) {

        let taskInfo = taskInfoForTask(dataTask)
        if taskInfo.delegate?.responds(to: #selector(urlSession(_:task:didReceive:completionHandler:))) != nil {
            taskInfo.delegate?.urlSession?(session, dataTask: dataTask, didReceive: response, completionHandler: completionHandler)
        } else {
            completionHandler(URLSession.ResponseDisposition.allow)
        }
    }

    func urlSession(_ session: URLSession, dataTask: URLSessionDataTask, didBecome downloadTask: URLSessionDownloadTask) {

        let taskInfo = taskInfoForTask(dataTask)
        if taskInfo.delegate?.responds(to: #selector(urlSession(_:dataTask:didBecome:))) != nil {
            taskInfo.delegate?.urlSession?(session, dataTask: dataTask, didBecome: downloadTask)
        }
    }

    func urlSession(_ session: URLSession, dataTask: URLSessionDataTask, didReceive data: Data) {

        let taskInfo = taskInfoForTask(dataTask)
        if taskInfo.delegate?.responds(to: #selector(urlSession(_:dataTask:didReceive:))) != nil {
            taskInfo.delegate?.urlSession?(session, dataTask: dataTask, didReceive: data)
        }
    }

    func urlSession(_ session: URLSession, dataTask: URLSessionDataTask, willCacheResponse proposedResponse: CachedURLResponse, completionHandler: @escaping (CachedURLResponse?) -> Void) {

        let taskInfo = taskInfoForTask(dataTask)
        if taskInfo.delegate?.responds(to: #selector(urlSession(_:dataTask:willCacheResponse:completionHandler:))) != nil {
            taskInfo.delegate?.urlSession?(session, dataTask: dataTask, willCacheResponse: proposedResponse, completionHandler: completionHandler)
        } else {
            completionHandler(proposedResponse)
        }
    }
}
