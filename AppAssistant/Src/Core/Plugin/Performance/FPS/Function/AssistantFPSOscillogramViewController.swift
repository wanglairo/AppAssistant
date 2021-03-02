//
//  AssistantFPSOscillogramViewController.swift
//  AppAssistant
//
//  Created by zhaochangwu on 2020/10/16.
//

import Foundation

class AssistantFPSOscillogramViewController: AssistantOscillogramViewController {

    var fpsUtil: AssistantFPSUtil?

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func title() -> String {
        return localizedString("帧率检测")
    }

    override func lowValue() -> String {
        return "0"
    }

    override func highValue() -> String {
        return "60"
    }

    override func closeBtnClick() {
        AssistantCacheManager.shared.saveFpsSwitch(false)
        AssistantFPSOscillogramWindow.sharedInstance.hide()
    }

    override func startRecord() {
        if fpsUtil == nil {
            fpsUtil = AssistantFPSUtil()
            fpsUtil?.addFPSBlock({ [weak self] (fps) in
                guard let self = self else {
                    return
                }
                self.oscillogramView.addHeightValue(CGFloat(CGFloat(fps) * self.oscillogramView.assk.height) / 60, tipValue: String(format: "%zi", fps))
            })
        }
        fpsUtil?.start()
    }

    override func endRecord() {
        if fpsUtil != nil {
            fpsUtil?.end()
        }
        self.oscillogramView.clear()
    }
}
