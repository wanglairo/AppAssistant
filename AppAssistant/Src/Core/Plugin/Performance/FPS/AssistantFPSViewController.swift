//
//  AssistantFPSViewController.swift
//  AppAssistant
//
//  Created by zhaochangwu on 2020/10/16.
//

import Foundation

class AssistantFPSViewController: UIViewController {

    var switchView = AssistantCellSwitch()

    override func viewDidLoad() {
        super.viewDidLoad()

        self.needBigTitleView = true
        self.assistant_setNavTitle(localizedString("帧率检测"))

        switchView.renderUIWithTitle(title: localizedString("帧率检测开关"), switchOn: AssistantCacheManager.shared.fpsSwitch())
        switchView.needTopLine()
        switchView.needDownLine()
        switchView.delegate = self
        self.view.addSubview(switchView)
        switchView.snp.makeConstraints { (maker) in
            maker.left.right.equalTo(0)
            maker.top.equalTo(AssistantMemoryViewController.bigTitleViewH)
            maker.height.equalTo(52)
        }

        AssistantFPSOscillogramWindow.sharedInstance.addDelegate(delegate: self)
    }

}

extension AssistantFPSViewController: AssistantOscillogramWindowDelegate {
    func assistantOscillogramWindowClosed() {
        switchView.renderUIWithTitle(title: localizedString("帧率检测开关"), switchOn: AssistantCacheManager.shared.fpsSwitch())
    }
}

extension AssistantFPSViewController: AssistantCellSwitchDelegate {
    func changeSwitchOn(isOn: Bool, sender: UISwitch) {
        AssistantCacheManager.shared.saveFpsSwitch(isOn)
        if isOn {
            AssistantFPSOscillogramWindow.sharedInstance.show()
        } else {
            AssistantFPSOscillogramWindow.sharedInstance.hide()
        }
    }
}
