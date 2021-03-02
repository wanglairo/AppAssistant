//
//  UIProfileViewController.swift
//  AppAssistant
//
//  Created by 王来 on 2020/11/16.
//

import UIKit

class UIProfileViewController: UIViewController {

    private lazy var switchView: AssistantCellSwitch = {
       let switchView = AssistantCellSwitch()
        switchView.renderUIWithTitle(title: localizedString("UI层级检查开关"), switchOn: UIProfileManager.shared.isEnable)
        switchView.needTopLine()
        switchView.needDownLine()
        switchView.delegate = self
        return switchView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        configUI()
    }

    private func configUI() {

        needBigTitleView = true
        assistant_setNavTitle(localizedString("UI层级"))

        self.view.addSubview(switchView)

        switchView.snp.makeConstraints { (maker) in
            maker.left.equalTo(0)
            maker.top.equalTo(UIProfileViewController.bigTitleViewH)
            maker.right.equalTo(0)
            maker.height.equalTo(53)
        }
    }

}

extension UIProfileViewController: AssistantCellSwitchDelegate {
    func changeSwitchOn(isOn: Bool, sender: UISwitch) {
        UIProfileManager.shared.isEnable = isOn
        if UIProfileManager.shared.isEnable {
            UIProfileManager.shared.start()
        } else {
            UIProfileManager.shared.stop()
        }
    }
}
