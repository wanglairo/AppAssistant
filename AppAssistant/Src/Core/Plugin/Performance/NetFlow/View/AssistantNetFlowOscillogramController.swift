//
//  AssistantNetFlowOscillogramController.swift
//  Alamofire
//
//  Created by 王来 on 2020/10/22.
//

import UIKit

class AssistantNetFlowOscillogramController: AssistantOscillogramViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func title() -> String {
        return "网络监控"
    }

    override func lowValue() -> String {
        return "0"
    }

    override func highValue() -> String {
        return "\(self.highestNetFlow())"
    }

    override func closeBtnClick() {
        AssistantCacheManager.shared.saveNetFlowSwitch(false)
        AssistantNetFlowOscillogramWindow.shared.hide()
    }

    // 每一秒钟采样一次流量情况
    override func doSecondFunction() {

        var useNetFlowForApp = 0
        let totalNetFlowForDevice = self.highestNetFlow()

        let now = Date().timeIntervalSince1970
        let start = now - 1

        let httpModelArray = NetFlowDataSource.shared.httpModelArray

        var totalNetFlow = 0
        for httpModel in httpModelArray {

            if let netFlowEndTime = httpModel.endTime {
                if netFlowEndTime >= start && netFlowEndTime <= now {

                    let upFlow = httpModel.uploadFlow
                    let downFlow = httpModel.downFlow
                    let upFlowInt = NSString(string: upFlow ?? "").intValue
                    let downFlowInt = NSString(string: downFlow ?? "").intValue
                    totalNetFlow += Int((upFlowInt + downFlowInt))
                }
            }
        }

        useNetFlowForApp = totalNetFlow

        // 0~highestNetFlow   对应 高度0~200
        // swiftlint:disable line_length
        oscillogramView.addHeightValue(CGFloat(useNetFlowForApp) * oscillogramView.assk.height / CGFloat(totalNetFlowForDevice), tipValue: NSString(format: "%ziB", useNetFlowForApp) as String)
    }

    func highestNetFlow() -> UInt {
        // 10000Byte
        return 1000
    }

}
