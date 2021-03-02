//
//  ToastUtil.swift
//  AppAssistant
//
//  Created by 王来 on 2020/11/18.
//

import UIKit

class ToastUtil: NSObject {
    static func showToast(_ text: String, superView: UIView?) {

        guard let superView = superView else {
            return
        }

        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14.fitSizeFrom750Landscape)
        label.text = text
        label.sizeToFit()
        label.textColor = .black
        // swiftlint:disable line_length
        label.frame = CGRect(x: superView.assk.width / 2 - label.assk.width / 2, y: superView.assk.height / 2 - label.assk.height / 2, width: label.assk.width, height: label.assk.height)
        // swiftlint:enable line_length
        superView.addSubview(label)
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + Double(Int64(1.5 * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC), execute: {
            label.removeFromSuperview()
        })
    }

    static func showToastBlack(_ text: String, superView: UIView?) {
        guard let superView = superView else {
            return
        }

        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 28.fitSizeFrom750Landscape)
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = 8.fitSizeFrom750Landscape
        paragraphStyle.alignment = .center
        let attributes = [NSAttributedString.Key.paragraphStyle: paragraphStyle]
        label.attributedText = NSAttributedString(string: localizedString(text), attributes: attributes)
        label.numberOfLines = 0
        let size = label.sizeThatFits(CGSize(width: superView.assk.width - 50, height: CGFloat.greatestFiniteMagnitude))
        label.backgroundColor = UIColor.black
        let padding = 37.fitSizeFrom750Landscape
        // swiftlint:disable line_length
        label.frame = CGRect(x: superView.assk.width / 2 - size.width / 2 - padding, y: superView.assk.height / 2 - size.height / 2 - padding, width: size.width + padding * 2, height: size.height + padding * 2)
        // swiftlint:enable line_length
        label.layer.cornerRadius = 8.fitSizeFrom750Landscape
        label.layer.masksToBounds = true
        label.textColor = UIColor.white
        superView.addSubview(label)
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + Double(Int64(1.5 * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC), execute: {
            label.removeFromSuperview()
        })
    }
}
