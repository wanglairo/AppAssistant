//
//  NetFlowInfoCell.swift
//  AppAssistant
//
//  Created by 王来 on 2020/10/20.
//

import UIKit

class NetFlowInfoCell: UITableViewCell {

    static let reuseIdentifier = "NetFlowInfoCell"

    // url信息
    private lazy var contentLabel: UITextView = {

        let textView = NetFlowInfoCell.getUITextView()
        textView.isScrollEnabled = false
        textView.isSelectable = false
        return textView
    }()

    var contentText: String? {
        didSet {
            contentLabel.text = contentText
        }
    }

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setUpUI()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func setUpUI() {

        contentView.backgroundColor = UIColor.white

        contentView.addSubview(contentLabel)
        contentLabel.snp.makeConstraints {
            $0.top.equalToSuperview().offset(10.fitSizeFrom750)
            $0.bottom.equalToSuperview().offset(-10.fitSizeFrom750)
            $0.left.equalToSuperview().offset(10.fitSizeFrom750)
            $0.right.equalToSuperview().offset(-10.fitSizeFrom750)
        }
    }

    static func cellHeightWithContent(content: String) -> CGFloat {

        let textView = NetFlowInfoCell.getUITextView()
        textView.text = content
        let fontSize = textView.sizeThatFits(CGSize(width: screenWidth - 20.fitSizeFrom750, height: CGFloat(MAXFLOAT)))
        return fontSize.height + 20.fitSizeFrom750
    }

    static func getUITextView() -> UITextView {

        let textView = UITextView()
        textView.font = UIFont.regular(16)
        textView.backgroundColor = .white
        return textView
    }

}
