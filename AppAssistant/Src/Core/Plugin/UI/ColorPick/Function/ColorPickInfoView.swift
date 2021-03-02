//
//  ColorPickInfoView.swift
//  AppAssistant
//
//  Created by 王来 on 2020/11/16.
//

import UIKit

extension VisualInfo {

    static let colorPick = VisualInfoWindow<ColorPickInfoView>(frame: rect)

    private static var rect: CGRect {
        let height: CGFloat = 100.fitSizeFrom750Landscape
        let margin: CGFloat = 30.fitSizeFrom750Landscape
        switch isInterfaceOrientationPortrait {
        case true:
            return .init(
                x: margin,
                y: screenHeight - height - margin - CGFloat(iPhoneSafebottomAreaHeight),
                width: screenWidth - 2 * margin,
                height: height
            )

        case false:
            return .init(
                x: margin,
                y: screenHeight - height - margin - CGFloat(iPhoneSafebottomAreaHeight),
                width: screenHeight - 2 * margin,
                height: height
            )
        }
    }
}

class ColorPickInfoView: UIView {

    private lazy var colorView: UIView = {
        $0.layer.borderWidth = 1
        $0.layer.borderColor = UIColor.assistant_blue().cgColor
        return $0
    }(UIView())

    private lazy var valueLabel: UILabel = {
        $0.textColor = .assistant_black_1()
        $0.font = .systemFont(ofSize: 28.fitSizeFrom750Landscape)
        return $0
    }(UILabel())

    private lazy var closeButton: UIButton = {
        let image = UIImage.assistant_xcassetImageNamed(name: "doraemon_close")
        $0.setBackgroundImage(image, for: .normal)
        $0.addTarget(self, action: #selector(closeAction), for: .touchUpInside)
        return $0
    }(UIButton())

    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setup() {
        layer.cornerRadius = 8.fitSizeFrom750Landscape
        layer.borderWidth = 1
        layer.borderColor = UIColor.assistant_blue().cgColor

        addSubview(colorView)
        addSubview(valueLabel)
        addSubview(closeButton)

        if #available(iOS 13.0, *) {
            backgroundColor = UIColor.dynamic(with: .white, dark: .secondarySystemGroupedBackground)
        } else {
            backgroundColor = .white
        }
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        let colorConst: CGFloat = 28.fitSizeFrom750Landscape
        colorView.frame = CGRect(
            x: 32.fitSizeFrom750Landscape,
            y: (assk.height - colorConst) / 2,
            width: colorConst,
            height: colorConst
        )
        valueLabel.frame = CGRect(
            x: colorView.assk.right + 20.fitSizeFrom750Landscape,
            y: 0,
            width: 150.fitSizeFrom750Landscape,
            height: assk.height
        )

        let closeConst: CGFloat = 44.fitSizeFrom750Landscape
        closeButton.frame = CGRect(
            x: assk.width - closeConst - 32.fitSizeFrom750Landscape,
            y: (assk.height - closeConst) / 2,
            width: closeConst,
            height: closeConst
        )
    }

    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        let image = UIImage.assistant_xcassetImageNamed(name: "doraemon_close")
        closeButton.setImage(image, for: .normal)
    }
}

// MARK: - Public
extension ColorPickInfoView {

    func set(current color: UIColor) {
        colorView.backgroundColor = color
        valueLabel.text = color.hexString
    }
}

// MARK: - Actions
extension ColorPickInfoView {

    @objc
    private func closeAction() {
        NotificationCenter.default.post(name: .closePlugin, object: nil)
    }
}
