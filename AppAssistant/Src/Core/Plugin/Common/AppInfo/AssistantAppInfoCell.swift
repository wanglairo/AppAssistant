//
//  AssistantAppInfoCell.swift
//  AppAssistant
//
//  Created by wangbao on 2020/9/30.
//

import Foundation

class AssistantAppInfoCell: UITableViewCell {

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        initUI()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func initUI() {

        contentView.backgroundColor = UIColor.white

        contentView.addSubview(titleLabel)
        contentView.addSubview(valueLabel)

        titleLabel.snp.makeConstraints { (maker) in
            maker.left.equalTo(32.fitSizeFrom750Landscape)
            maker.top.equalTo(0)
            maker.bottom.equalTo(0)
        }
        valueLabel.snp.makeConstraints { (maker) in
            maker.left.equalTo(titleLabel.snp.right).offset(10)
            maker.right.equalTo(-32.fitSizeFrom750Landscape)
            maker.top.equalTo(0)
            maker.bottom.equalTo(0)
        }
    }

    private lazy var titleLabel: UILabel = {
        let titleLabel = UILabel()
        titleLabel.textColor = UIColor.assistant_black_1()
        titleLabel.font = UIFont.systemFont(ofSize: 32.fitSizeFrom750Landscape)
        return titleLabel
    }()

    private lazy var valueLabel: UILabel = {
        let valueLabel = UILabel()
        valueLabel.textColor = UIColor.assistant_black_2()
        valueLabel.textAlignment = .right
        valueLabel.font = UIFont.systemFont(ofSize: 32.fitSizeFrom750Landscape)
        return valueLabel
    }()

    static func cellHeight() -> CGFloat {
        return 104.fitSizeFrom750Landscape
    }

    func renderUIWithData(data: [String: String]) {
        let title = data["title"]
        let value = data["value"]

        titleLabel.text = title

        let cnValue: String
        if value == "NotDetermined" {
            cnValue = "用户没有选择"
        } else if value == "Restricted" {
            cnValue = "家长控制"
        } else if value == "Denied" {
            cnValue = "用户没有授权"
        } else if value == "Authorized" {
            cnValue = "用户已经授权"
        } else {
            cnValue = value ?? ""
        }

        valueLabel.text = cnValue
    }

}
