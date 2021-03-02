//
//  AssistantMemoryOscillogramViewController.swift
//  Alamofire
//
//  Created by wangbao on 2020/10/15.
//

import Foundation

class AssistantMemoryOscillogramViewController: AssistantOscillogramViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func title() -> String {
        return "内存检测"
    }

    override func lowValue() -> String {
        return "0"
    }

    override func highValue() -> String {
        return String(format: "%zi", self.deviceMemory())
    }

    override func closeBtnClick() {
        AssistantCacheManager.shared.saveMemorySwitch(false)
        AssistantMemoryOscillogramWindow.sharedInstance.hide()
    }
    // 每一秒钟采样一次内存使用率
    override func doSecondFunction() {
        let useMemoryForApp = CGFloat(AssistantMemoryUtil.useMemoryForApp())
        let totalMemoryForDevice = CGFloat(self.deviceMemory())
        self.oscillogramView.addHeightValue(useMemoryForApp * self.oscillogramView.assk.height / totalMemoryForDevice,
                                            tipValue: String(format: "%zi", Int(useMemoryForApp)))
    }

    func deviceMemory() -> Int {
        return 1000
    }
}
