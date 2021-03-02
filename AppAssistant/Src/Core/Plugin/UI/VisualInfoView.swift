//
//  VisualInfoView.swift
//  AppAssistant
//
//  Created by 王来 on 2020/11/9.
//

import UIKit

extension VisualInfo {

    static let defalut = VisualInfoWindow<VisualInfoView>(frame: rect)

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

class VisualInfoView: UIView {

    private lazy var valueLabel: UILabel = {
        $0.textColor = .assistant_black_1()
        $0.font = .systemFont(ofSize: 24.fitSizeFrom750Landscape)
        $0.adjustsFontSizeToFitWidth = true
        $0.minimumScaleFactor = 0.5
        $0.numberOfLines = 0
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

        addSubview(valueLabel)
        addSubview(closeButton)

        backgroundColor = .white
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        let closeConst: CGFloat = 44.fitSizeFrom750Landscape
        closeButton.frame = CGRect(
            x: assk.width - 32.fitSizeFrom750Landscape - closeConst,
            y: (assk.height - closeConst) / 2,
            width: closeConst,
            height: closeConst
        )

        valueLabel.frame = CGRect(
            x: 32.fitSizeFrom750Landscape,
            y: 0,
            width: closeButton.frame.minX - 32.fitSizeFrom750Landscape - 10.fitSizeFrom750Landscape,
            height: assk.height
        )
    }

    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        let image = UIImage.assistant_xcassetImageNamed(name: "doraemon_close")
        closeButton.setImage(image, for: .normal)
    }
}

// MARK: - Public
extension VisualInfoView {

    func set(text: String) {
        valueLabel.text = text
    }
}

// MARK: - Actions
extension VisualInfoView {

    @objc
    private func closeAction() {
        NotificationCenter.default.post(name: .closePlugin, object: nil)
    }
}
