//
//  AssistantMethodUseTimeListCell.swift
//  AppAssistant
//
//  Created by wangbao on 2020/11/16.
//

import Foundation

class AssistantMethodUseTimeListCell: UITableViewCell {

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        selectionStyle = .none

        self.contentView.addSubview(titleLabel)
        self.contentView.addSubview(rightLabel)
        titleLabel.snp.makeConstraints { (maker) in
            maker.left.equalTo(32.fitSizeFrom750Landscape)
            maker.centerY.equalTo(self.snp_centerY)
            maker.right.equalTo(100.fitSizeFrom750Landscape)
        }
        rightLabel.snp.makeConstraints { (maker) in
            maker.right.equalTo(-32.fitSizeFrom750Landscape)
            maker.centerY.equalTo(self.snp_centerY)
        }
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func renderCellWithData(dic: [String: Any]) {
        titleLabel.text = dic["name"] as? String ?? ""
        titleLabel.adjustsFontSizeToFitWidth = true
        titleLabel.minimumScaleFactor = 0.1

        let cost = dic["cost"] as? String ?? ""
        let costString = String(format: "%.3fms", cost)
        rightLabel.text = costString
    }

    private lazy var titleLabel: UILabel = {
       var label = UILabel()
        label.textColor = .assistant_black_1()
        label.font = UIFont.systemFont(ofSize: 28.fitSizeFrom750Landscape)
        return label
    }()

    private lazy var rightLabel: UILabel = {
       var label = UILabel()
        label.textColor = .assistant_blue()
        label.font = UIFont.systemFont(ofSize: 28.fitSizeFrom750Landscape)
        return label
    }()

    static func cellHeight() -> CGFloat {
        return 104.fitSizeFrom750Landscape
    }
}
