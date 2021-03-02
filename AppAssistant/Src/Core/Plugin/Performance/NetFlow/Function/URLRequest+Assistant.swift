//
//  URLRequest+Assistant.swift
//  Alamofire
//
//  Created by 王来 on 2020/10/19.
//

extension URLRequest {

    struct URLRequestKey {
        static var requestId = "URLRequest.requestId"
        static var startTime = "URLRequest.startTime"
    }

    var requestId: String? {
        get {
            return objc_getAssociatedObject(self, &URLRequestKey.requestId) as? String
        }
        set {
            objc_setAssociatedObject(self, &URLRequestKey.requestId, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }

    }

    var startTime: NSNumber? {
        get {
            return objc_getAssociatedObject(self, &URLRequestKey.startTime) as? NSNumber
        }
        set(newValue) {
            objc_setAssociatedObject(self, &URLRequestKey.startTime, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }

    }

}
