//
//  AssinstantLaunchTimeViewController.swift
//  Alamofire
//
//  Created by wangbao on 2020/11/5.
//

import Foundation

class AssinstantLaunchTimeViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        needBigTitleView = true
        assistant_setNavTitle(localizedString("启动耗时"))

        let cellBtn = AssistantCellButton()
        cellBtn.renderUIWithTitle(title: localizedString("本次启动时间为："))
        cellBtn.renderUIWithRightContent(rightContent: "\(AssistantLaunchTime.latency) s")
        cellBtn.needDownLine()
        self.view.addSubview(cellBtn)

        cellBtn.snp.makeConstraints { (maker) in
            maker.left.right.equalTo(0)
            maker.top.equalTo(UIViewController.bigTitleViewH)
            maker.height.equalTo(104.fitSizeFrom750Landscape)
        }
    }
}
