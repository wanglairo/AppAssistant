//
//  AssistantToastUtil.swift
//  AppAssistant
//
//  Created by 王来 on 2020/10/9.
//

import Foundation

class AssistantToastUtil: NSObject {

    static func showToast(text: String, inView superView: UIView) {

        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14.fitSizeFrom750Landscape)
        label.text = text
        if #available(iOS 13.0, *) {
            label.textColor = .label
        } else {
            label.textColor = .black
        }
        superView.addSubview(label)
        label.snp.makeConstraints { (maker) in
            maker.center.equalTo(superView.snp.center)
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
            label.removeFromSuperview()
        }
    }

    static func showToastBlack(text: String, inView superView: UIView?) {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 28.fitSizeFrom750Landscape)
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = 8.fitSizeFrom750Landscape
        paragraphStyle.alignment = .center
        label.attributedText = NSAttributedString(string: localizedString(text), attributes: [NSAttributedString.Key.paragraphStyle: paragraphStyle])
        label.numberOfLines = 0
        let size = label.sizeThatFits(CGSize(width: (superView?.assk.width ?? 0) - 50, height: CGFloat.greatestFiniteMagnitude))
        if #available(iOS 13.0, *) {
            label.backgroundColor = .label
        } else {
            label.backgroundColor = .black
        }
        let padding = 37.fitSizeFrom750Landscape
        let left = (superView?.assk.width ?? 0) / 2 - size.width / 2 - padding
        let top = (superView?.assk.height ?? 0) / 2 - size.height / 2 - padding
        label.frame = CGRect(
            x: left,
            y: top,
            width: (size.width + padding * 2),
            height: (size.height + padding * 2))
        label.layer.cornerRadius = 8.fitSizeFrom750Landscape
        label.layer.masksToBounds = true
        label.textColor = UIColor.white
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
            label.removeFromSuperview()
        }
    }
}
