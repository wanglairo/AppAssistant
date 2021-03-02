//
//  AssistantCPUViewController.swift
//  Alamofire
//
//  Created by wangbao on 2020/10/19.
//

import Foundation

class AssistantCPUViewController: UIViewController {

    var switchView = AssistantCellSwitch()

    override func viewDidLoad() {
        super.viewDidLoad()

        self.needBigTitleView = true
        self.assistant_setNavTitle(localizedString("CPU检测"))

        switchView.renderUIWithTitle(title: localizedString("CPU检测开关"), switchOn: AssistantCacheManager.shared.cpuSwitch())
        switchView.needTopLine()
        switchView.needDownLine()
        switchView.delegate = self
        self.view.addSubview(switchView)
        switchView.snp.makeConstraints { (maker) in
            maker.left.right.equalTo(0)
            maker.top.equalTo(AssistantMemoryViewController.bigTitleViewH)
            maker.height.equalTo(52)
        }

        AssistantCPUOscillogramWindow.sharedInstance.addDelegate(delegate: self)
    }

}

extension AssistantCPUViewController: AssistantOscillogramWindowDelegate {
    func assistantOscillogramWindowClosed() {
        switchView.renderUIWithTitle(title: localizedString("CPU检测开关"), switchOn: AssistantCacheManager.shared.cpuSwitch())
    }
}

extension AssistantCPUViewController: AssistantCellSwitchDelegate {
    func changeSwitchOn(isOn: Bool, sender: UISwitch) {
        AssistantCacheManager.shared.saveCpuSwitch(isOn)
        if isOn {
            AssistantCPUOscillogramWindow.sharedInstance.show()
        } else {
            AssistantCPUOscillogramWindow.sharedInstance.hide()
        }
    }
}
