//
//  NSObject+MemoryLeak.swift
//  AppAssistant
//
//  Created by 王来 on 2020/11/23.
//

import FBRetainCycleDetector

var wlist = NSMutableSet()

extension NSObject {

    struct ViewStackKey {
        static var stackKey = "NSObject.ViewStackKey"
    }

    struct ParentPtrsKey {
        static var ptrsKey = "NSObject.ParentPtrsKey"
    }

    struct LatestSenderKey {
        static var senderKey = "NSObject.LatestSenderKey"
    }

    @objc
    func willDealloc() -> Bool {

        let className = NSStringFromClass(type(of: self))
        if NSObject.classNamesWlist().contains(className) {
            return false
        }

        guard let senderPtr = objc_getAssociatedObject(UIApplication.shared, &NSObject.LatestSenderKey.senderKey) as? NSNumber else {
            return false
        }

        var sampleStruct = self
        let checksum = withUnsafeBytes(of: &sampleStruct) { (bytes) -> UInt32 in
            return ~bytes.reduce(UInt32(0)) { $0 + numericCast($1) }
        }

        if senderPtr.uintValue == checksum {
            return false
        }

        DispatchQueue.main.asyncAfter(deadline: .now() + 2) { [weak self] in
            guard let self = self else {
                return
            }
            self.assertNotDealloc()
        }
        return true
    }

    func assertNotDealloc() {
        if MLeakedObjectProxy.isAnyObjectLeakedAtPtrs(getParentPtrs()) {
            return
        }
        MLeakedObjectProxy.addLeakedObject(self)
        let className = NSStringFromClass(type(of: self))
        // swiftlint:disable line_length
        print("Possibly Memory Leak.\nIn case that \(className) should not be dealloced, override -willDealloc in \(className) by returning NO.\nView-ViewController stack: \(self.viewStack())")
    }

    func willReleaseObject(_ object: NSObject, relationship: String) {

        var relationShip = relationship
        if relationship.hasPrefix("self") {

            let start = relationship.index(relationship.startIndex, offsetBy: 0)
            let end = relationship.index(relationship.startIndex, offsetBy: 4)
            let range = Range(uncheckedBounds: (lower: start, upper: end))
            relationShip = relationship.replacingCharacters(in: range, with: "")
        }

        var className = NSStringFromClass(type(of: object))
        className = "\(relationShip)(\(className)), "
        object.setViewStack(viewStack().adding(className))
        object.setParentPtrs(getParentPtrs().adding("\(getUnsafeBytes(sampleStruct: object))") as NSSet)
        _ = object.willDealloc()
    }

    func willReleaseChild(_ child: NSObject? = nil) {

        guard let child = child else {
            return
        }
        willReleaseChildren([child])
    }

    func willReleaseChildren(_ children: [NSObject]) {
        let viewS = viewStack()
        let parentPtrs = getParentPtrs()
        for child in children {
            let className = NSStringFromClass(type(of: child))
            child.setViewStack(viewS.adding(className))
            let bytes = getUnsafeBytes(sampleStruct: child)
            child.setParentPtrs(parentPtrs.adding("\(bytes)") as NSSet)
            _ = child.willDealloc()
        }
    }

    func viewStack() -> NSArray {

        guard let viewStack = objc_getAssociatedObject(self, &NSObject.ViewStackKey.stackKey) as? NSArray else {

            let className = NSStringFromClass(type(of: self))
            return [className]
        }
        return viewStack
    }

    func setViewStack(_ viewStack: [Any]) {
        objc_setAssociatedObject(self, &NSObject.ViewStackKey.stackKey, viewStack, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
    }

    func setParentPtrs(_ parentPtrs: NSSet) {
        objc_setAssociatedObject(self, &NSObject.ParentPtrsKey.ptrsKey, parentPtrs, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
    }

    func getParentPtrs() -> NSSet {

        guard let parentPtrs = objc_getAssociatedObject(self, &NSObject.ParentPtrsKey.ptrsKey) as? NSSet else {
            return NSSet(objects: "\(getUnsafeBytes(sampleStruct: self))")
        }
        return parentPtrs
    }

    static func classNamesWlist() -> NSMutableSet {
        DispatchQueue.once(token: "whitelist") {
            wlist = NSMutableSet(objects: "UIFieldEditor", "UINavigationBar", "_UIAlertControllerActionView", "_UIVisualEffectBackdropView", "UIAlertController")
            let systemVersion = NSString(string: UIDevice.current.systemVersion)
            if systemVersion.compare("10.0", options: .numeric) == .orderedAscending {
                wlist.add("UISwitch")
            }
        }
        return wlist
    }

    static func addClassNamesToWlist(_ classNames: [Any]) {
        self.classNamesWlist().addObjects(from: classNames)
    }

    static func swizzleSEL(_ oriSel: Selector, swiSel: Selector) {

        DispatchQueue.once(token: "FBHook]") {
            FBAssociationManager.hook()
        }

        guard let oriMethod = class_getInstanceMethod(self, oriSel),
              let swizzledMethod = class_getInstanceMethod(self, swiSel) else {
            return
        }
        let didAddMethod = class_addMethod(self, oriSel, method_getImplementation(swizzledMethod), method_getTypeEncoding(swizzledMethod))
        if didAddMethod {
            class_replaceMethod(self, swiSel, method_getImplementation(oriMethod), method_getTypeEncoding(oriMethod))
        } else {
            method_exchangeImplementations(oriMethod, swizzledMethod)
        }
    }

}

func getUnsafeBytes(sampleStruct: Any) -> UInt {
    var value = sampleStruct
    let checksum = withUnsafeBytes(of: &value) { (bytes) -> UInt32 in
        return ~bytes.reduce(UInt32(0)) { $0 + numericCast($1) }
    }
    return UInt(checksum)
}
