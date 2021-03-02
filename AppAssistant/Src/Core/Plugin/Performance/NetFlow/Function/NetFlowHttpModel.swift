//
//  NetFlowHttpModel.swift
//  Alamofire
//
//  Created by 王来 on 2020/10/19.
//

struct NetFlowHttpModel {

    var requestId: String?

    var url: String?

    var method: String?

    var requestBody: String?

    var statusCode: String?

    var responseData: Data?

    var responseBody: String?

    var mineType: String?

    var startTime: TimeInterval?

    var endTime: TimeInterval?

    var totalDuration: String?

    /// 上行流量 单位字节B
    var uploadFlow: String?

    /// 下行流量 单位字节B
    var downFlow: String?

    var request: URLRequest?

    var response: URLResponse?

    /// 流量触发时候的顶层vc
    var topVc: String?

    static func dealWithResponseData(_ responseData: Data,
                                     response: URLResponse,
                                     request: URLRequest) -> NetFlowHttpModel {
        var httpModel = NetFlowHttpModel()
        // request
        httpModel.request = request
        httpModel.requestId = request.requestId
        httpModel.url = request.url?.absoluteString
        httpModel.method = request.httpMethod

        let httpBody = AssistantUrlUtil.getHttpBodyFromRequest(request)
        httpModel.requestBody = AssistantUrlUtil.convertJsonFromData(httpBody)
        httpModel.uploadFlow = "\(AssistantUrlUtil.getRequestLength(request))"

        // response
        httpModel.mineType = response.mimeType
        httpModel.response = response
        let httpResponse = response as? HTTPURLResponse
        httpModel.statusCode = "\(Int32(httpResponse?.statusCode ?? 0))"
        httpModel.responseData = responseData
        httpModel.responseBody = AssistantUrlUtil.convertJsonFromData(responseData)
        httpModel.totalDuration = String(format: "%.2fs", Date().timeIntervalSince1970 - (request.startTime?.doubleValue ?? 0.0))
        httpModel.downFlow = "\(AssistantUrlUtil.getResponseLength(httpResponse ?? HTTPURLResponse(), data: responseData))"
        return httpModel
    }

}
