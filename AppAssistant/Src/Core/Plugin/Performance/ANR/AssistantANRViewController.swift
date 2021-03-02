//
//  AssistantANRViewController.swift
//  Alamofire
//
//  Created by wangbao on 2020/11/2.
//

import Foundation

class AssistantANRViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        needBigTitleView = true
        assistant_setNavTitle(localizedString("卡顿检测"))

        self.view.addSubview(switchView)
        self.view.addSubview(checkBtn)
        self.view.addSubview(clearBtn)

        switchView.snp.makeConstraints { (maker) in
            maker.left.equalTo(0)
            maker.top.equalTo(AssistantANRViewController.bigTitleViewH)
            maker.right.equalTo(0)
            maker.height.equalTo(53)
        }

        checkBtn.snp.makeConstraints { (maker) in
            maker.left.equalTo(0)
            maker.top.equalTo(switchView.snp.bottom)
            maker.right.equalTo(0)
            maker.height.equalTo(53)
        }

        clearBtn.snp.makeConstraints { (maker) in
            maker.left.equalTo(0)
            maker.top.equalTo(checkBtn.snp.bottom)
            maker.right.equalTo(0)
            maker.height.equalTo(104.fitSizeFrom750Landscape)
        }
    }

    private lazy var switchView: AssistantCellSwitch = {
       let switchView = AssistantCellSwitch()
        switchView.renderUIWithTitle(title: localizedString("卡顿检测开关"), switchOn: AssistantANRManager.sharedInstance.anrTrackOn)
        switchView.needTopLine()
        switchView.needDownLine()
        switchView.delegate = self
        return switchView
    }()

    private lazy var checkBtn: AssistantCellButton = {
        let checkBtn = AssistantCellButton()
        checkBtn.renderUIWithTitle(title: localizedString("查看卡顿记录"))
        checkBtn.delegate = self
        checkBtn.needDownLine()
        return checkBtn
    }()

    private lazy var clearBtn: AssistantCellButton = {
        let clearBtn = AssistantCellButton()
        clearBtn.renderUIWithTitle(title: localizedString("一键清理卡顿记录"))
        clearBtn.delegate = self
        clearBtn.needDownLine()
        return clearBtn
    }()

}

extension AssistantANRViewController: AssistantCellSwitchDelegate {
    func changeSwitchOn(isOn: Bool, sender: UISwitch) {
        AssistantANRManager.sharedInstance.anrTrackOn = isOn
        if isOn {
            AssistantANRManager.sharedInstance.start()
        } else {
            AssistantANRManager.sharedInstance.stop()
        }
    }
}

extension AssistantANRViewController: AssistantCellButtonDelegate {
    func cellBtnClick(sender: UIView) {
        if sender == checkBtn {
            let vc = AssistantANRListViewController()
            self.navigationController?.pushViewController(vc, animated: true)
        } else if sender == clearBtn {
            let alertVC = UIAlertController(title: localizedString("提示"), message: localizedString("确认删除所有卡顿记录吗？"), preferredStyle: .alert)
            let cancelAction = UIAlertAction(title: localizedString("取消"), style: .cancel) { (_) in
            }
            let okAction = UIAlertAction(title: localizedString("确定"), style: .default) { (_) in
                do {
                    try FileManager.default.removeItem(atPath: "")
                    AssistantToastUtil.showToast(text: localizedString("删除成功"), inView: self.view)
                } catch {
                    // 删除失败
                    AssistantToastUtil.showToast(text: localizedString("删除失败"), inView: self.view)
                }
            }
            alertVC.addAction(cancelAction)
            alertVC.addAction(okAction)
            present(alertVC, animated: true, completion: nil)
        }
    }
}
