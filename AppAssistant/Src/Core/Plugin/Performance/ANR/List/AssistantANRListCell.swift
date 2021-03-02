//
//  AssistantANRListCell.swift
//  AppAssistant
//
//  Created by wangbao on 2020/11/2.
//

import Foundation

class AssistantANRListCell: UITableViewCell {

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.selectionStyle = .none

        self.contentView.addSubview(titleLabel)
        self.contentView.addSubview(arrowImageView)
        titleLabel.snp.makeConstraints { (maker) in
            maker.left.equalTo(32.fitSizeFrom750Landscape)
            maker.centerY.equalTo(self.snp.centerY)
            maker.right.equalTo(-120.fitSizeFrom750Landscape)
        }
        arrowImageView.snp.makeConstraints { (maker) in
            maker.centerY.equalTo(self.snp.centerY)
            maker.right.equalTo(-32.fitSizeFrom750Landscape)
        }
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private lazy var titleLabel: UILabel = {
        let title = UILabel()
        title.textColor = .assistant_black_1()
        title.font = UIFont.systemFont(ofSize: 32.fitSizeFrom750Landscape)
        return title
    }()

    private lazy var arrowImageView: UIImageView = {
        let arrow = UIImageView(image: UIImage.assistant_xcassetImageNamed(name: "doraemon_more"))
        return arrow
    }()

    func renderCell(title: String) {
        self.titleLabel.text = title
    }

    static func cellHeight() -> CGFloat {
        return 104.fitSizeFrom750Landscape
    }

}
