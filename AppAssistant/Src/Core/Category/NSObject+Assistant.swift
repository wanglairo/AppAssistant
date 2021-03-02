//
//  NSObject+Assistant.swift
//  AppAssistant
//
//  Created by wangbao on 2020/10/21.
//

import Foundation

extension NSObject {

    static func assistant_swizzleClassMethodWithOriginSel(oriSel: Selector, swiSel: Selector) {
        guard let originAddObserverMethod = class_getClassMethod(self, oriSel),
           let swizzledAddObserverMethod = class_getClassMethod(self, swiSel) else {
            return
        }
        self.swizzleMethodWithOriginSel(oriSel: oriSel,
                                        oriMethod: originAddObserverMethod,
                                        swizzledSel: swiSel,
                                        swizzledMethod: swizzledAddObserverMethod,
                                        cls: self)
    }

    static func assistant_swizzleInstanceMethodWithOriginSel(oriSel: Selector, swiSel: Selector) {
        guard let originAddObserverMethod = class_getInstanceMethod(self, oriSel),
              let swizzledAddObserverMethod = class_getInstanceMethod(self, swiSel) else {
            return
        }
        self.swizzleMethodWithOriginSel(oriSel: oriSel,
                                        oriMethod: originAddObserverMethod,
                                        swizzledSel: swiSel,
                                        swizzledMethod: swizzledAddObserverMethod,
                                        cls: self)
    }

    static func swizzleMethodWithOriginSel(oriSel: Selector, oriMethod: Method, swizzledSel: Selector, swizzledMethod: Method, cls: AnyClass) {
        let didAddMethod = class_addMethod(cls, oriSel, method_getImplementation(swizzledMethod), method_getTypeEncoding(swizzledMethod))
        if didAddMethod {
            class_replaceMethod(cls, swizzledSel, method_getImplementation(oriMethod), method_getTypeEncoding(oriMethod))
        } else {
            method_exchangeImplementations(oriMethod, swizzledMethod)
        }
    }
}

extension DispatchQueue {

    private static var _onceTracker = [String]()

    class func once(token: String, block:() -> Void) {
        objc_sync_enter(self)
        defer {
            objc_sync_exit(self)
        }

        if _onceTracker.contains(token) {
            return
        }

        _onceTracker.append(token)
        block()
    }
}
