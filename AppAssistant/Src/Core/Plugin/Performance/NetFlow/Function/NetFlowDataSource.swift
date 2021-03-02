//
//  NetFlowDataSource.swift
//  Alamofire
//
//  Created by 王来 on 2020/10/19.
//

class NetFlowDataSource: NSObject {

    static let shared = NetFlowDataSource()

    var httpModelArray = [NetFlowHttpModel]()

    var semaphore = DispatchSemaphore(value: 1)

    func addHttpModel(httpModel: NetFlowHttpModel) {
        semaphore.wait()
        httpModelArray.insert(httpModel, at: 0)
        semaphore.signal()
    }

    func clear() {
        semaphore.wait()
        httpModelArray.removeAll()
        semaphore.signal()
    }
}
