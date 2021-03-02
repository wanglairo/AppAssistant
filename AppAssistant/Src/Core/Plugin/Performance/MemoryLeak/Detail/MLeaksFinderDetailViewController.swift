//
//  MLeaksFinderDetailViewController.swift
//  AppAssistant
//
//  Created by 王来 on 2020/11/23.
//

import UIKit

class MLeaksFinderDetailViewController: UIViewController {

    var info: [String: Any]?

    private lazy var contentLabel: UILabel = {

        let contentLabel = UILabel()
        contentLabel.textColor = .assistant_black_2()
        contentLabel.font = .regular(14)
        contentLabel.numberOfLines = 0
        return contentLabel
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .assistant_bg()
        assistant_setNavBack()
        assistant_setNavTitle(localizedString("内存泄漏详情"))

        contentLabel.text = info?.description
        let contentHeight = contentLabel.sizeThatFits(CGSize(width: screenWidth - 20 * 2, height: CGFloat(MAXFLOAT))).height

        view.addSubview(contentLabel)
        contentLabel.snp.makeConstraints { (maker) in
            maker.left.equalToSuperview().offset(20.fitSizeFrom750)
            maker.right.equalToSuperview().offset(-20.fitSizeFrom750)
            maker.top.equalToSuperview().offset(0)
            maker.height.equalTo(contentHeight)
        }
    }

}
