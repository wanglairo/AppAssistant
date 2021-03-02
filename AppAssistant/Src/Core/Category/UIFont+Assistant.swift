//
//  UIFont+Assistant.swift
//  AppAssistant
//
//  Created by 王来 on 2020/10/9.
//

extension UIFont {

    static func normalWithName(_ fontName: String, size fontSize: CGFloat) -> UIFont? {
        let scaleSize: CGFloat = (fontSize * screenWidth / 375.0)
        if let font = UIFont(name: fontName, size: scaleSize) {
            return font
        }
        return UIFont.systemFont(ofSize: scaleSize)
    }

    static func medium(_ fontSize: CGFloat) -> UIFont? {
        return UIFont.normalWithName("PingFangSC-Medium", size: fontSize)
    }

    static func regular(_ fontSize: CGFloat) -> UIFont? {
        return UIFont.normalWithName("PingFangSC-Regular", size: fontSize)
    }

    static func semiblod(_ fontSize: CGFloat) -> UIFont? {
        return UIFont.normalWithName("PingFangSC-Semibold", size: fontSize)
    }

    static func display(_ fontSize: CGFloat) -> UIFont? {
        return UIFont.normalWithName(".SFNSDisplay", size: fontSize)
    }

}
