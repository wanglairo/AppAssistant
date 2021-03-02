//
//  AssistantMemoryViewController.swift
//  Alamofire
//
//  Created by wangbao on 2020/10/15.
//

import Foundation

class AssistantMemoryViewController: UIViewController {

    var switchView = AssistantCellSwitch()

    override func viewDidLoad() {
        super.viewDidLoad()

        self.needBigTitleView = true
        self.assistant_setNavTitle("内存检测")

        switchView.renderUIWithTitle(title: "内存检测开关", switchOn: AssistantCacheManager.shared.memorySwitch())
        switchView.needTopLine()
        switchView.needDownLine()
        switchView.delegate = self
        self.view.addSubview(switchView)
        switchView.snp.makeConstraints { (maker) in
            maker.left.right.equalTo(0)
            maker.top.equalTo(AssistantMemoryViewController.bigTitleViewH)
            maker.height.equalTo(52)
        }

        AssistantMemoryOscillogramWindow.sharedInstance.addDelegate(delegate: self)
    }

}

extension AssistantMemoryViewController: AssistantOscillogramWindowDelegate {
    func assistantOscillogramWindowClosed() {
        switchView.renderUIWithTitle(title: "内存检测开关", switchOn: AssistantCacheManager.shared.memorySwitch())
    }
}

extension AssistantMemoryViewController: AssistantCellSwitchDelegate {
    func changeSwitchOn(isOn: Bool, sender: UISwitch) {
        AssistantCacheManager.shared.saveMemorySwitch(isOn)
        if isOn {
            AssistantMemoryOscillogramWindow.sharedInstance.show()
        } else {
            AssistantMemoryOscillogramWindow.sharedInstance.hide()
        }
    }
}
