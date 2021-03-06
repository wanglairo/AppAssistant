//
//  CrashListCell.swift
//  AppAssistant
//
//  Created by 王来 on 2020/11/17.
//

import UIKit

protocol CrashListCellDelegate: NSObjectProtocol {
    func switchAction(cell: CrashListCell, _ isOn: Bool, handle: @escaping (Bool) -> Void)
}

class CrashListCell: UITableViewCell {

    static let identifier: String = "CrashListCell"

    weak var delegate: CrashListCellDelegate?

    private lazy var _switch: UISwitch = {
        $0.onTintColor = .blue
        $0.addTarget(self, action: #selector(switchAction), for: .valueChanged)
        return $0
    }( UISwitch(frame: .zero) )

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .default, reuseIdentifier: reuseIdentifier)
        setup()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setup() {
        accessoryType = .disclosureIndicator
        textLabel?.font = .systemFont(ofSize: 32.fitSizeFrom750Landscape)
    }
}

// MARK: - Public
extension CrashListCell {

    enum Mode {
        case indicator
        case `switch`(isOn: Bool)
    }

    func set(_ mode: Mode) {
        switch mode {
        case .indicator:
            accessoryType = .disclosureIndicator
            selectionStyle = .default

        case .switch(let isOn):
            selectionStyle = .none
            accessoryView = _switch
            _switch.isOn = isOn
        }
    }

    func set(text: String) {
        textLabel?.text = text
    }
}

extension CrashListCell {

    @objc
    func switchAction(_ sender: UISwitch) {
        delegate?.switchAction(cell: self, sender.isOn) { [weak self] isOK  in
            guard !isOK else {
                return
            }
            self?._switch.setOn(!sender.isOn, animated: true)
        }
    }
}
