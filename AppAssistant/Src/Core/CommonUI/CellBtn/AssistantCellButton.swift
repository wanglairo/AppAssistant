//
//  AssistantCellButton.swift
//  AppAssistant
//
//  Created by 王来 on 2020/10/9.
//

import Foundation

protocol AssistantCellButtonDelegate: NSObjectProtocol {
    func cellBtnClick(sender: UIView)
}

class AssistantCellButton: UIView {

    weak var delegate: AssistantCellButtonDelegate?

    override init(frame: CGRect) {
        super.init(frame: frame)

        setupUI()
        setupConstraint()

        isUserInteractionEnabled = true
        addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(tap)))
    }

    func setupUI() {
        addSubview(titleLabel)
        addSubview(topLine)
        addSubview(downLine)
        addSubview(arrowImageView)
        addSubview(rightLabel)
    }

    func setupConstraint() {
        titleLabel.snp.makeConstraints { (maker) in
            maker.left.equalTo(20)
            maker.centerY.equalTo(self.snp.centerY)
        }
        arrowImageView.snp.makeConstraints { (maker) in
            maker.right.equalTo(-32.fitSizeFrom750Landscape)
            maker.centerY.equalTo(self.snp.centerY)
        }
        rightLabel.snp.makeConstraints { (maker) in
            maker.centerY.equalTo(self.snp.centerY)
            maker.right.equalTo(arrowImageView.snp.left).offset(-24.fitSizeFrom750Landscape)
        }
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    @objc
    func tap() {
        delegate?.cellBtnClick(sender: self)
    }

    internal lazy var titleLabel: UILabel = {
        let title = UILabel()
        title.textColor = .assistant_black_1()
        title.font = UIFont.systemFont(ofSize: 32.fitSizeFrom750Landscape)
        return title
    }()

    private lazy var topLine: UIView = {
        let line = UIView()
        line.isHidden = true
        line.backgroundColor = .assistant_line()
        return line
    }()

    private lazy var downLine: UIView = {
        let line = UIView()
        line.isHidden = true
        line.backgroundColor = .assistant_line()
        return line
    }()

    private lazy var arrowImageView: UIImageView = {
        let arrowImageView = UIImageView(image: UIImage.assistant_xcassetImageNamed(name: "doraemon_more"))
        return arrowImageView
    }()

    private lazy var rightLabel: UILabel = {
       let right = UILabel()
        right.isHidden = true
        right.textColor = .assistant_black_2()
        right.font = UIFont.systemFont(ofSize: 32.fitSizeFrom750Landscape)
        return right
    }()

    func renderUIWithTitle(title: String) {
        titleLabel.text = title
    }

    func renderUIWithRightContent(rightContent: String) {
        rightLabel.isHidden = false
        rightLabel.text = rightContent
    }

    func needTopLine() {
        topLine.isHidden = false
        topLine.snp_remakeConstraints { (maker) in
            maker.left.equalTo(0)
            maker.top.equalTo(0)
            maker.right.equalTo(0)
            maker.height.equalTo(0.5)
        }
    }

    func needDownLine() {
        downLine.isHidden = false
        downLine.snp_remakeConstraints { (maker) in
            maker.left.equalTo(0)
            maker.bottom.equalTo(0)
            maker.right.equalTo(0)
            maker.height.equalTo(0.5)
        }
    }
}
