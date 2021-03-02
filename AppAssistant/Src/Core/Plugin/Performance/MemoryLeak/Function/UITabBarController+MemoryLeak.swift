//
//  UITabBarController+MemoryLeak.swift
//  AppAssistant
//
//  Created by wangbao on 2020/11/26.
//

import Foundation

extension UITabBarController {

    override func willDealloc() -> Bool {
        if super.willDealloc() == false {
            return false
        }
        self.willReleaseChildren(self.viewControllers ?? [UIViewController()])
        return true
    }

}
