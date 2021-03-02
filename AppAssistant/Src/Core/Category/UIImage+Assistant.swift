//
//  UIImage+Assistant.swift
//  AppAssistant
//
//  Created by 王来 on 2020/10/9.
//

import Foundation

extension UIImage {

    static func assistant_xcassetImageNamed(name: String) -> UIImage? {

        if name.isEmpty {
            return nil
        }
        let bundle = Bundle(for: AssistantManager.self)
        guard let url = bundle.url(forResource: "AppAssistant", withExtension: "bundle") else {
            return nil
        }
        let imageBundle = Bundle(url: url)
        let image = UIImage(named: name, in: imageBundle, compatibleWith: nil)
        return image
    }

    /// 重设图片大小
    /// - Parameter size: 新的图片大小
    func assistantResize(_ size: CGSize) -> UIImage {
        UIGraphicsBeginImageContextWithOptions(size, false, scale)
        draw(in: CGRect(origin: .zero, size: size))
        let reSizeImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return reSizeImage ?? self
    }

    /// 用颜色初始化一张图片，默认大小为（1，1）
    ///
    /// - Parameters:
    ///   - color: 对应颜色
    ///   - size: 生成图片大小
    convenience init?(color: UIColor, size: CGSize = CGSize(width: 1, height: 1)) {
        let rect = CGRect(origin: CGPoint.zero, size: size)
        UIGraphicsBeginImageContext(size)
        guard let context = UIGraphicsGetCurrentContext() else {
            return nil
        }
        context.setFillColor(color.cgColor)
        context.fill(rect)
        guard let image = UIGraphicsGetImageFromCurrentImageContext()?.cgImage else {
            return nil }
        self.init(cgImage: image)
        UIGraphicsEndImageContext()
    }
}
