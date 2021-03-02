//
//  AssistantUtil.swift
//  Alamofire
//
//  Created by 王来 on 2020/10/19.
//

protocol SharedProtocal {

}

extension URL: SharedProtocal {}
extension String: SharedProtocal {}
extension UIImage: SharedProtocal {}

struct AssistantUtil {

    // byte格式化为 B KB MB 方便流量查看
    static func formatByte(_ byte: Float) -> String {
        var convertedValue = CDouble(byte)
        var multiplyFactor: Int32 = 0

        let tokens = ["B", "KB", "MB", "GB", "TB"]
        while convertedValue > 1024 {
            convertedValue /= 1024
            multiplyFactor += 1
        }
        return String(format: "%4.2f%@", convertedValue, tokens[Int(multiplyFactor)])
    }

    static func dateFormatTimeInterval(_ timeInterval: TimeInterval) -> String {
        let date = Date(timeIntervalSince1970: timeInterval)
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let dateString: String = formatter.string(from: date)
        return dateString
    }

    static func dateFormatNow() -> String {
        let date = Date()
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let dateString: String = formatter.string(from: date)
        return dateString
    }

    static func getKeyWindow() -> UIWindow {
        var keyWindow = UIWindow()
        guard (UIApplication.shared.delegate?.window) == nil else {
            keyWindow = (UIApplication.shared.delegate?.window) as? UIWindow ?? UIWindow()
            return keyWindow
        }
        let windows = UIApplication.shared.windows
        windows.forEach { (window) in
            if window.isHidden == false {
                keyWindow = window
                return
            }
        }
        return keyWindow
    }

    static func share(obj: SharedProtocal, from: UIViewController) {
        let controller = UIActivityViewController(activityItems: [obj], applicationActivities: nil)
        if AssistantAppInfoUtil.isIpad() {
            controller.popoverPresentationController?.sourceView = from.view
            controller.popoverPresentationController?.sourceRect = CGRect(x: 0, y: 0, width: screenWidth, height: 400)
        }
        from.present(controller, animated: true, completion: nil)
    }
}

/// 分享
extension AssistantUtil {

    static func share(with image: UIImage, _ controller: UIViewController, completion: ((_ : Bool) -> Swift.Void)? = nil) {
        _share(with: image, controller, completion: completion)
    }

    static func share(with text: String, _ controller: UIViewController, completion: ((_ : Bool) -> Swift.Void)? = nil) {
        _share(with: text, controller, completion: completion)
    }

    static func share(with url: URL, _ controller: UIViewController, completion: ((_ : Bool) -> Swift.Void)? = nil) {
        _share(with: url, controller, completion: completion)
    }

    private static func _share(with object: Any, _ controller: UIViewController, completion: ((_ : Bool) -> Void)?) {
        let activity = UIActivityViewController(activityItems: [object], applicationActivities: nil)
        activity.completionWithItemsHandler = { (_, result, _, _) in
            completion?(result)
        }

        if Device.isPad {
            activity.popoverPresentationController?.sourceView = controller.view
        } else {
            controller.present(activity, animated: true)
        }
    }
}
