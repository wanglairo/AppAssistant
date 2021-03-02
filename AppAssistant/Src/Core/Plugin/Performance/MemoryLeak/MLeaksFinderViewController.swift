//
//  MLeaksFinderViewController.swift
//  AppAssistant
//
//  Created by 王来 on 2020/11/20.
//

import UIKit

class MLeaksFinderViewController: UIViewController, AssistantCellSwitchDelegate, AssistantCellButtonDelegate {

    private lazy var switchView: AssistantCellSwitch = {
       let switchView = AssistantCellSwitch()
        switchView.renderUIWithTitle(title: localizedString("内存泄漏检测开关"), switchOn: AssistantCacheManager.shared.memoryLeak())
        switchView.needTopLine()
        switchView.needDownLine()
        switchView.delegate = self
        return switchView
    }()

    private lazy var alertSwitchView: AssistantCellSwitch = {
       let switchView = AssistantCellSwitch()
        switchView.renderUIWithTitle(title: localizedString("内存泄漏检测弹框提醒"), switchOn: AssistantCacheManager.shared.memoryLeakAlert())
        switchView.needTopLine()
        switchView.needDownLine()
        switchView.delegate = self
        return switchView
    }()

    private lazy var cellBtn: AssistantCellButton = {
        let checkBtn = AssistantCellButton()
        checkBtn.renderUIWithTitle(title: localizedString("查看检测记录"))
        checkBtn.delegate = self
        checkBtn.needDownLine()
        return checkBtn
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        needBigTitleView = true
        assistant_setNavBack()
        assistant_setNavTitle(localizedString("内存泄漏"))

        self.view.addSubview(switchView)
        self.view.addSubview(alertSwitchView)
        self.view.addSubview(cellBtn)

        switchView.snp.makeConstraints { (maker) in
            maker.left.equalTo(0)
            maker.top.equalTo(AssistantANRViewController.bigTitleViewH)
            maker.right.equalTo(0)
            maker.height.equalTo(53.fitSizeFrom750Landscape)
        }

        alertSwitchView.snp.makeConstraints { (maker) in
            maker.left.equalTo(0)
            maker.top.equalTo(switchView.snp.bottom)
            maker.right.equalTo(0)
            maker.height.equalTo(53.fitSizeFrom750Landscape)
        }

        cellBtn.snp.makeConstraints { (maker) in
            maker.left.equalTo(0)
            maker.top.equalTo(alertSwitchView.snp.bottom)
            maker.right.equalTo(0)
            maker.height.equalTo(53.fitSizeFrom750Landscape)
        }
    }
    func changeSwitchOn(isOn: Bool, sender: UISwitch) {
        if sender == switchView.switchView {
            AssistantAlertUtil.handleAlertActionWithVC(vc: self, okBlock: {
                AssistantCacheManager.shared.saveMemoryLeak(isOn)
                exit(0)
            }, cancelBlock: { [weak self] in
                self?.switchView.switchView.isOn = !isOn
            })
        } else {
            AssistantCacheManager.shared.saveMemoryLeakAlert(isOn)
        }
    }

    func cellBtnClick(sender: UIView) {
        if sender == cellBtn {
            let mle = MLeaksFinderListViewController()
            navigationController?.pushViewController(mle, animated: true)
        }
    }
}
