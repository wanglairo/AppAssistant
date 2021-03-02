//
//  UIApplication+MemoryLeak.swift
//  AppAssistant
//
//  Created by wangbao on 2020/11/26.
//

import Foundation

extension UIApplication {

    static func onceApplicationSwizzle() {
        if AssistantCacheManager.shared.memoryLeak() {
            DispatchQueue.once(token: "UIApplication") {
                UIApplication.swizzleSEL(#selector(sendAction(_:to:from:for:)), swiSel: #selector(swizzledSendAction(action:to:from:forEvent:)))
            }
        }
    }

    @objc
    func swizzledSendAction(action: Selector, to target: AnyObject, from sender: Any, forEvent event: UIEvent ) -> Bool {

        var sampleStruct = sender
        let checksum = withUnsafeBytes(of: &sampleStruct) { (bytes) -> UInt32 in
            return ~bytes.reduce(UInt32(0)) { $0 + numericCast($1) }
        }
        objc_setAssociatedObject(self, &LatestSenderKey.senderKey, NSNumber(value: checksum), .OBJC_ASSOCIATION_RETAIN)
        return self.swizzledSendAction(action: action, to: target, from: sender, forEvent: event)
    }

}
