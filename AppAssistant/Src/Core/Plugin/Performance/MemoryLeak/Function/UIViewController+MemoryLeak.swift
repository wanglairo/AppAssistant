//
//  UIViewController+MemoryLeak.swift
//  AppAssistant
//
//  Created by wangbao on 2020/11/25.
//

import Foundation

let kHasBeenPoppedKey = "&kHasBeenPoppedKey"

extension UIViewController {

    struct HasBeenPoppedKey {
        static var kHasBeenPoppedKey = "UIViewController.hasBeenPoppedKey"
    }

    static func onceSwizzleMethod() {
        if AssistantCacheManager.shared.memoryLeak() {
            DispatchQueue.once(token: "uiviewcontroller") {
                let originalDisappearSelector = #selector(UIViewController.viewDidDisappear(_:))
                let swizzledDisappearSelector = #selector(UIViewController.swizzledViewDidDisappear(_:))
                UIViewController.assistant_swizzleInstanceMethodWithOriginSel(oriSel: originalDisappearSelector, swiSel: swizzledDisappearSelector)

                let originalWillappearSelector = #selector(UIViewController.viewWillAppear(_:))
                let swizzledWillappearSelector = #selector(UIViewController.swizzledViewWillAppear(_:))
                UIViewController.assistant_swizzleInstanceMethodWithOriginSel(oriSel: originalWillappearSelector, swiSel: swizzledWillappearSelector)

                let originalDismissViewSelector = #selector(UIViewController.dismiss(animated:completion:))
                let swizzledDismissViewSelector = #selector(UIViewController.swizzledDismissViewControllerAnimated(flag:completion:))
                UIViewController.assistant_swizzleInstanceMethodWithOriginSel(oriSel: originalDismissViewSelector, swiSel: swizzledDismissViewSelector)
            }
        }
    }

    @objc
    func swizzledViewDidDisappear(_ animated: Bool) {

        self.swizzledViewDidDisappear(animated)
        let popkey = objc_getAssociatedObject(self, &HasBeenPoppedKey.kHasBeenPoppedKey) as? Bool
        if popkey == true {
            _ = self.willDealloc()
        }
    }

    @objc
    func swizzledViewWillAppear(_ animated: Bool) {

        self.swizzledViewWillAppear(animated)
        objc_setAssociatedObject(self, &HasBeenPoppedKey.kHasBeenPoppedKey, false, .OBJC_ASSOCIATION_RETAIN)
    }

    @objc
    func swizzledDismissViewControllerAnimated(flag: Bool, completion: (() -> Void)? = nil) {

        self.swizzledDismissViewControllerAnimated(flag: flag, completion: completion)
        var dismissViewController = self.presentedViewController
        if (dismissViewController != nil) && (self.presentingViewController != nil) {
            dismissViewController = self
        }
        if dismissViewController == nil {
            return
        }
        _ = dismissViewController?.willDealloc()
    }

    // swiftlint:disable override_in_extension
    override func willDealloc() -> Bool {

        if super.willDealloc() == false {
            return false
        }
        self.willReleaseChildren(self.children)
        self.willReleaseChild(self.presentedViewController)
        if self.isViewLoaded {
            self.willReleaseChild(self.view)
        }
        return true
    }
}
