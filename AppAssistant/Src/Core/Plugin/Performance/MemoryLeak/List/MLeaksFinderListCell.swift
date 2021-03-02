//
//  MLeaksFinderListCell.swift
//  AppAssistant
//
//  Created by 王来 on 2020/11/20.
//

import UIKit

class MLeaksFinderListCell: UITableViewCell {

    private lazy var titleLabel: UILabel = {

        let titleLabel = UILabel()
        titleLabel.textColor = .assistant_black_1()
        titleLabel.font = .regular(14)
        return titleLabel
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        setUI()
    }

    func setUI() {

        addSubview(titleLabel)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func renderCellWithData(dic: [String: Any]) {
        if let className = dic["className"] as? String {

            titleLabel.text = className
            titleLabel.sizeToFit()
            // swiftlint:disable line_length
            titleLabel.frame = CGRect(x: 32.fitSizeFrom750Landscape, y: MLeaksFinderListCell.cellHeight() / 2 - titleLabel.assk.height / 2, width: screenWidth - 120, height: titleLabel.assk.height)
            titleLabel.adjustsFontSizeToFitWidth = true
            titleLabel.minimumScaleFactor = 0.1
        }
    }

    static func cellHeight() -> CGFloat {
        return 104.fitSizeFrom750Landscape
    }

}
