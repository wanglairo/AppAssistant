//
//  UIView+MemoryLeak.swift
//  AppAssistant
//
//  Created by wangbao on 2020/11/25.
//

import Foundation

extension UIView {

    // swiftlint:disable override_in_extension
    override func willDealloc() -> Bool {

        if super.willDealloc() == false {
            return false
        }
        self.willReleaseChildren(self.subviews)
        return true
    }

}
