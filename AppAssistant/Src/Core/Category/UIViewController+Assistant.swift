//
//  UIViewController+Assistant.swift
//  AppAssistant
//
//  Created by 王来 on 2020/11/16.
//

import Foundation
import UIKit

extension UIViewController {
    static func rootViewControllerForDoKitHomeWindow() -> UIViewController? {
        return AssistantHomeWindow.shared.rootViewController
    }

    static func rootViewControllerForKeyWindow() -> UIViewController? {
        return AssistantUtil.getKeyWindow().rootViewController
    }

    static func topViewControllerForKeyWindow() -> UIViewController? {
        let keyWindow = AssistantUtil.getKeyWindow()
        var vc = self.topViewControllerForKeyWindow(vc: keyWindow.rootViewController)
        if vc == nil {
            return nil
        }
        if vc?.presentingViewController != nil {
            vc = self.topViewControllerForKeyWindow(vc: vc?.presentingViewController)
        }
        return vc
    }

    static func topViewControllerForKeyWindow(vc: UIViewController?) -> UIViewController? {
        if let vc = vc {
            if vc is UINavigationController {
                let nav: UINavigationController = vc as? UINavigationController ?? UINavigationController()
                return self.topViewControllerForKeyWindow(vc: nav.topViewController)
            } else if vc is UITabBarController {
                let tab: UITabBarController = vc as? UITabBarController ?? UITabBarController()
                return self.topViewControllerForKeyWindow(vc: tab.selectedViewController)
            } else {
                return vc
            }
        } else {
            return nil
        }
    }

    @discardableResult
    func showAlert(title: String?,
                   message: String?,
                   buttonTitles: [String]? = nil,
                   highlightedButtonIndex: Int? = nil,
                   completion: ((Int) -> Void)? = nil) -> UIAlertController {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        var allButtons = buttonTitles ?? [String]()
        if allButtons.isEmpty {
            allButtons.append("OK")
        }
        for index in 0..<allButtons.count {
            let buttonTitle = allButtons[index]
            let action = UIAlertAction(title: buttonTitle, style: .default, handler: { (_) in
                completion?(index)
            })
            alertController.addAction(action)
            if let highlightedButtonIndex = highlightedButtonIndex, index == highlightedButtonIndex {
                alertController.preferredAction = action
            }
        }
        present(alertController, animated: true, completion: nil)
        return alertController
    }
}
