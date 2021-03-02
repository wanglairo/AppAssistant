//
//  AssistantANRDetailViewController.swift
//  AppAssistant
//
//  Created by wangbao on 2020/11/2.
//

import Foundation

class AssistantANRDetailViewController: UIViewController {

    var filePath = ""

    override func viewDidLoad() {
        super.viewDidLoad()

        assistant_setNavTitle(localizedString("卡顿详情"))
        assistant_setNavRight(titleText: localizedString("导出"), imageText: "", titleColor: UIColor.assistant_blue())
        self.view.backgroundColor = .white
        self.view.addSubview(anrTimeLabel)
        self.view.addSubview(contentLabel)
        contentLabel.snp.makeConstraints { (maker) in
            maker.left.equalTo(20)
            maker.top.equalTo(10)
            maker.right.equalTo(-20)
        }
        anrTimeLabel.snp.makeConstraints { (maker) in
            maker.left.equalTo(20)
            maker.top.equalTo(contentLabel.snp.bottom).offset(20)
        }
        if let anrInfo = NSDictionary(contentsOfFile: filePath) {
            contentLabel.text = anrInfo["content"] as? String ?? ""
            anrTimeLabel.text = String(format: "anr time : %@ms", anrInfo["duration"] as? String ?? "")
        }
    }

    override func assistant_rightBtnClick(sender: UIButton) {
        AssistantUtil.share(obj: URL(fileURLWithPath: filePath), from: self)
    }

    private lazy var anrTimeLabel: UILabel = {
       let timeLabel = UILabel()
        timeLabel.textColor = .assistant_black_1()
        timeLabel.font = UIFont.systemFont(ofSize: 16.fitSizeFrom750Landscape)
        return timeLabel
    }()

    private lazy var contentLabel: UILabel = {
       let contentLabel = UILabel()
        contentLabel.textColor = .assistant_black_2()
        contentLabel.font = UIFont.systemFont(ofSize: 16.fitSizeFrom750Landscape)
        contentLabel.numberOfLines = 0
        return contentLabel
    }()

}
