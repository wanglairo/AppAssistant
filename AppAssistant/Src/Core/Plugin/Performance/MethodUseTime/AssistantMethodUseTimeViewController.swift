//
//  AssistantMethodUseTimeViewController.swift
//  Alamofire
//
//  Created by wangbao on 2020/11/10.
//

import Foundation

class AssistantMethodUseTimeViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        needBigTitleView = true
        assistant_setNavTitle(localizedString("Load耗时"))
        setupView()
    }

    func setupView() {
        view.addSubview(switchView)
        view.addSubview(cellBtn)
        switchView.snp.makeConstraints { (maker) in
            maker.left.equalTo(0)
            maker.top.equalTo(UIViewController.bigTitleViewH)
            maker.right.equalTo(0)
            maker.height.equalTo(53)
        }
        cellBtn.snp.makeConstraints { (maker) in
            maker.left.equalTo(0)
            maker.right.equalTo(0)
            maker.top.equalTo(switchView.snp_bottom)
            maker.height.equalTo(53)
        }
    }

    private lazy var switchView: AssistantCellSwitch = {
        let switchView = AssistantCellSwitch()
        switchView.renderUIWithTitle(title: localizedString("Load耗时检测开关"), switchOn: AssistantMethodUseTimeManager.sharedInstance.switchOn)
        switchView.needTopLine()
        switchView.needDownLine()
        switchView.delegate = self
        return switchView
    }()

    private lazy var cellBtn: AssistantCellButton = {
        let cellBtn = AssistantCellButton()
        cellBtn.renderUIWithTitle(title: localizedString("查看检测记录"))
        cellBtn.delegate = self
        cellBtn.needDownLine()
        return cellBtn
    }()

}

extension AssistantMethodUseTimeViewController: AssistantCellSwitchDelegate {

    func changeSwitchOn(isOn: Bool, sender: UISwitch) {
        AssistantAlertUtil.handleAlertActionWithVC(vc: self, okBlock: {
            AssistantMethodUseTimeManager.sharedInstance.switchOn = isOn
            exit(0)
        }, cancelBlock: { [weak self] in
            self?.switchView.switchView.isOn = !isOn
        })
    }
}

extension AssistantMethodUseTimeViewController: AssistantCellButtonDelegate {

    func cellBtnClick(sender: UIView) {
        if sender == cellBtn {
            let listViewController = AssistantMethodUseTimeListViewController()
            self.navigationController?.pushViewController(listViewController, animated: true)
        }
    }
}
