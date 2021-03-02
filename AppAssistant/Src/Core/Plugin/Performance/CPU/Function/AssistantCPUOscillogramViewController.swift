//
//  CPUOscillogramViewController.swift
//  AppAssistant
//
//  Created by zhaochangwu on 2020/10/15.
//

import Foundation

class AssistantCPUOscillogramViewController: AssistantOscillogramViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func title() -> String {
        return localizedString("CPU检测")
    }

    override func lowValue() -> String {
        return "0"
    }

    override func highValue() -> String {
        return "100"
    }

    override func closeBtnClick() {
        AssistantCacheManager.shared.saveCpuSwitch(false)
        AssistantCPUOscillogramWindow.sharedInstance.hide()
    }

    override func doSecondFunction() {
        var cpuUsage = AssistantCPUUtil.cpuUsage()
        if cpuUsage > 100 {
            cpuUsage = 100
        }
        self.oscillogramView.addHeightValue(CGFloat(cpuUsage) * self.oscillogramView.assk.height / 100, tipValue: String(format: "%.f", cpuUsage))
    }
}
