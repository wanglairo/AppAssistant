//
//  NetFlowManager.swift
//  Alamofire
//
//  Created by 王来 on 2020/10/19.
//

class NetFlowManager: NSObject, NetworkInterceptorDelegate {

    static let shared = NetFlowManager()

    private var canIntercept: Bool?

    var startInterceptDate: NSDate?

    func canInterceptNetFlow(_ enable: Bool) {
        canIntercept = enable
        if enable {
            NetworkInterceptor.shareInstance.addDelegate(self)
            startInterceptDate = NSDate()
        } else {
            NetworkInterceptor.shareInstance.removeDelegate(self)
            startInterceptDate = nil
            NetFlowDataSource.shared.clear()
        }
    }

    func networkInterceptorDidReceiveData(data: Data, response: URLResponse, request: URLRequest, error: NSError, startTime: TimeInterval) {

        var httpModel = NetFlowHttpModel.dealWithResponseData(data, response: response, request: request)

        if !error.domain.isEmpty {
            httpModel.statusCode = error.localizedDescription
        }

        httpModel.startTime = startTime
        httpModel.endTime = Date().timeIntervalSince1970

        httpModel.totalDuration = String(format: "%.2f", Date().timeIntervalSince1970 - startTime)

        NetFlowDataSource.shared.addHttpModel(httpModel: httpModel)
    }

    func shouldIntercept() -> Bool {
        return canIntercept ?? false
    }

}
