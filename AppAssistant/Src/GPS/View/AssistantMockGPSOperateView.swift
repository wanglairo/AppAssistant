//
//  AssistantMockGPSOperateView.swift
//  AppAssistant
//
//  Created by wangbao on 2020/10/10.
//

import Foundation
import SnapKit

class AssistantMockGPSOperateView: UIView {

    var switchView = UISwitch()

    override init(frame: CGRect) {
        super.init(frame: frame)

        if #available(iOS 13.0, *) {
            backgroundColor = .systemBackground
        } else {
            backgroundColor = .white
        }

        self.layer.cornerRadius = 16.fitSizeFrom750Landscape
        switchView.onTintColor = UIColor.assistant_blue()
        self.addSubview(switchView)
        self.addSubview(titleLable)
        titleLable.snp.makeConstraints { (maker) in
            maker.left.equalTo(32.fitSizeFrom750Landscape)
            maker.centerY.equalTo(self.snp_centerY)
        }
        switchView.snp.makeConstraints { (maker) in
            maker.right.equalTo(-32.fitSizeFrom750Landscape)
            maker.centerY.equalTo(self.snp_centerY)
        }
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    lazy var titleLable: UILabel = {
        let titleLable = UILabel()
        titleLable.font = UIFont.systemFont(ofSize: 32.fitSizeFrom750Landscape)
        titleLable.textColor = UIColor.assistant_black_1()
        titleLable.text = localizedString("打开Mock GPS")
        titleLable.sizeToFit()
        return titleLable
    }()

}
