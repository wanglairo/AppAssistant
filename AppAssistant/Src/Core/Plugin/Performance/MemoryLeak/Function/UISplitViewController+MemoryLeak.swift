//
//  UISplitViewController+MemoryLeak.swift
//  AppAssistant
//
//  Created by wangbao on 2020/11/26.
//

import Foundation

extension UISplitViewController {

    // swiftlint:disable override_in_extension
    override func willDealloc() -> Bool {
        if super.willDealloc() == false {
            return false
        }
        self.willReleaseChildren(self.viewControllers)
        return true
    }

}
