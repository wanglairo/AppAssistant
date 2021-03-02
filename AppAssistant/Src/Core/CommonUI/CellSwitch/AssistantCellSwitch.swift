//
//  AssistantCellSwitch.swift
//  AppAssistant
//
//  Created by 王来 on 2020/10/9.
//

import Foundation

protocol AssistantCellSwitchDelegate: NSObjectProtocol {

    func changeSwitchOn(isOn: Bool, sender: UISwitch)

}

class AssistantCellSwitch: UIView {

    weak var delegate: AssistantCellSwitchDelegate?

    override init(frame: CGRect) {
        super.init(frame: frame)

        addSubview(titleLabel)
        addSubview(switchView)
        addSubview(topLine)
        addSubview(downLine)

        titleLabel.snp.makeConstraints { (maker) in
            maker.left.equalTo(20)
            maker.centerY.equalTo(self.snp_centerY)
        }
        switchView.snp.makeConstraints { (maker) in
            maker.right.equalTo(-16)
            maker.centerY.equalTo(self.snp_centerY)
        }
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor.assistant_black_1()
        label.font = UIFont.systemFont(ofSize: 32.fitSizeFrom750Landscape)
        return label
    }()

    lazy var switchView: UISwitch = {
        let switchView = UISwitch()
        switchView.onTintColor = UIColor.assistant_blue()
        switchView.addTarget(self, action: #selector(switchChange), for: .touchUpInside)
        return switchView
    }()

    lazy var topLine: UILabel = {
        let line = UILabel()
        line.isHidden = true
        line.backgroundColor = UIColor.assistant_line()
        return line
    }()

    lazy var downLine: UILabel = {
        let downLine = UILabel()
        downLine.isHidden = true
        downLine.backgroundColor = .assistant_line()
        return downLine
    }()

    func needTopLine() {
        topLine.isHidden = false
        topLine.snp.remakeConstraints { (maker) in
            maker.left.top.right.equalTo(0)
            maker.height.equalTo(0.5)
        }
    }

    func needDownLine() {
        downLine.isHidden = false
        downLine.snp.remakeConstraints { (maker) in
            maker.left.right.bottom.equalTo(0)
            maker.height.equalTo(0.5)
        }
    }

    func renderUIWithTitle(title: String, switchOn: Bool) {
        titleLabel.text = title
        switchView.isOn = switchOn
    }

    @objc
    func switchChange(sender: UISwitch) {
        let isOn = sender.isOn
        delegate?.changeSwitchOn(isOn: isOn, sender: sender)
    }
}
