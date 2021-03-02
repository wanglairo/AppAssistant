//
//  UINavigationController+MemoryLeak.m.swift
//  AppAssistant
//
//  Created by wangbao on 2020/11/26.
//

import Foundation

extension UINavigationController {

    struct PoppedDetailVCKey {
        static var kPopDetailVCKey = "UINavigationController.popDetailVCKey"
    }

    static func navigationSwizzleMethod() {
        DispatchQueue.once(token: "UINavigationController") {
            UINavigationController.swizzleSEL(#selector(UINavigationController.pushViewController(_:animated:)),
                                              swiSel: #selector( UINavigationController.swizzledPushViewController(viewController:animated:)))

            UINavigationController.swizzleSEL(#selector(UINavigationController.popViewController(animated:)),
                                              swiSel: #selector(UINavigationController.swizzledPopViewControllerAnimated(animated:)))

            UINavigationController.swizzleSEL(#selector(UINavigationController.popToViewController(_:animated:)),
                                              swiSel: #selector(UINavigationController.swizzledPopToViewController(viewController:animated:)))

            UINavigationController.swizzleSEL(#selector(UINavigationController.popToRootViewController(animated:)),
                                              swiSel: #selector(UINavigationController.swizzledPopToRootViewControllerAnimated(animated:)))
        }
    }

    @objc
    func swizzledPushViewController(viewController: UIViewController, animated: Bool) {
        if self.splitViewController != nil {
            let detailViewController = objc_getAssociatedObject(self, &PoppedDetailVCKey.kPopDetailVCKey) as? UIViewController ?? UIViewController()
            if NSStringFromClass(type(of: detailViewController)) == "UIViewController" {
                _ = detailViewController.willDealloc()
                objc_setAssociatedObject(self, &PoppedDetailVCKey.kPopDetailVCKey, nil, .OBJC_ASSOCIATION_RETAIN)
            }
        }
        self.swizzledPushViewController(viewController: viewController, animated: animated)
    }

    @objc
    func swizzledPopViewControllerAnimated(animated: Bool) -> UIViewController? {
        let viewController = self.swizzledPopViewControllerAnimated(animated: animated)
        guard let poppedViewController = viewController else {
            return nil
        }
        if self.splitViewController != nil &&
            self.splitViewController?.viewControllers.first == self &&
            self.splitViewController == poppedViewController.splitViewController {
            objc_setAssociatedObject(self, &PoppedDetailVCKey.kPopDetailVCKey, poppedViewController, .OBJC_ASSOCIATION_RETAIN)
            return poppedViewController
        }
        objc_setAssociatedObject(poppedViewController, &HasBeenPoppedKey.kHasBeenPoppedKey, true, .OBJC_ASSOCIATION_RETAIN)
        return poppedViewController
    }

    @objc
    func swizzledPopToViewController(viewController: UIViewController, animated: Bool) -> [UIViewController] {
        let poppedViewControllers = self.swizzledPopToViewController(viewController: viewController, animated: animated)
        for viewController in poppedViewControllers {
            _ = viewController.willDealloc()
        }
        return poppedViewControllers
    }

    @objc
    func swizzledPopToRootViewControllerAnimated(animated: Bool) -> [UIViewController] {
        let poppedViewControllers = self.swizzledPopToRootViewControllerAnimated(animated: animated)
        for viewController in poppedViewControllers {
            _ = viewController.willDealloc()
        }
        return poppedViewControllers
    }

    // swiftlint:disable override_in_extension
    override func willDealloc() -> Bool {
        if super.willDealloc() == false {
            return false
        }
        self.willReleaseChildren(self.viewControllers)
        return true
    }
}
