//
//  MLeakedObjectProxy.swift
//  AppAssistant
//
//  Created by 王来 on 2020/11/23.
//

import FBRetainCycleDetector

private var leakedObjectPtrs = NSMutableSet()

class MLeakedObjectProxy {

    struct LeakedObjectProxyKey {
        static var proxyKey = "MLeakedObjectProxy.proxyKey"
    }

    var object: Any?
    var objectPtr: UInt?
    var viewStack: NSArray?

    static func isAnyObjectLeakedAtPtrs(_ ptrs: NSSet) -> Bool {

        assert(Thread.isMainThread, "Must be in main thread.")
        // swiftlint:disable empty_count
        if ptrs.count == 0 {
            return false
        }

        if leakedObjectPtrs.intersects(ptrs as? Set<AnyHashable> ?? Set<AnyHashable>()) {
            return true
        } else {
            return false
        }
    }

    static func addLeakedObject(_ object: NSObject) {

        assert(Thread.isMainThread, "Must be in main thread.")
        let proxy = MLeakedObjectProxy()
        proxy.object = object
        proxy.objectPtr = getUnsafeBytes(sampleStruct: object)
        proxy.viewStack = object.viewStack()

        objc_setAssociatedObject(object, &MLeakedObjectProxy.LeakedObjectProxyKey.proxyKey, proxy, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)

        leakedObjectPtrs.add(proxy.object as Any)
        MemoryLeakData.shared.addObject(object: object)
        if AssistantCacheManager.shared.memoryLeakAlert() {
            AssistantAlertUtil.handleAlertActionWithVC(
                vc: UIViewController.rootViewControllerForKeyWindow() ?? UIViewController(),
                title: "Memory Leak",
                text: "\(proxy.viewStack ?? NSArray())",
                cancelTitle: "Retain Cycle",
                okTitle: "OK",
                okBlock: {
                },
                cancelBlock: {
                    proxy.searchRetainCycle()
                }
            )
        }
    }

    deinit {
        DispatchQueue.main.async {
            leakedObjectPtrs.remove(self.objectPtr as Any)
            MemoryLeakData.shared.removeObjectPtr(objectPtr: NSNumber(value: self.objectPtr ?? 0))
            AssistantAlertUtil.handleAlertActionWithVC(
                vc: UIViewController.rootViewControllerForKeyWindow() ?? UIViewController(),
                title: "Object Deallocated",
                text: "\(self.viewStack ?? NSArray())",
                okTitle: "OK",
                okBlock: {
                },
                cancelBlock: {
                }
            )
        }
    }

    func searchRetainCycle() {

        guard let object = object else {
            return
        }

        DispatchQueue.global().async { [self] in
            let detector = FBRetainCycleDetector()
            detector.addCandidate(self.object as Any)

            let retainCycles = detector.findRetainCycles(withMaxCycleLength: 20)

            var hasFound = false
            for retainCycle in retainCycles {
                if let retainCycle = retainCycle as? [Any] {
                    for (index, element) in retainCycle.enumerated() {
                        if let element = element as? FBObjectiveCGraphElement, element.object as? NSObject == object as? NSObject {
                            let shiftedRetainCycle = shiftArray(retainCycle, toIndex: index)
                            DispatchQueue.main.async {
                                AssistantAlertUtil.handleAlertActionWithVC(
                                    vc: UIViewController.rootViewControllerForKeyWindow() ?? UIViewController(),
                                    title: "Retain Cycle",
                                    text: "\(shiftedRetainCycle)",
                                    okTitle: "OK",
                                    okBlock: {
                                    },
                                    cancelBlock: {
                                    }
                                )
                            }
                            hasFound = true
                            break
                        }
                    }
                    if hasFound {
                        break
                    }
                }
            }
            DispatchQueue.main.async {
                AssistantAlertUtil.handleAlertActionWithVC(
                    vc: UIViewController.rootViewControllerForKeyWindow() ?? UIViewController(),
                    title: "Retain Cycle",
                    text: "Fail to find a retain cycle",
                    okTitle: "OK",
                    okBlock: {
                    },
                    cancelBlock: {
                    }
                )
            }
        }
    }

    func shiftArray(_ array: [Any], toIndex index: Int) -> [Any] {

        if index == 0 {
            return array
        }

        let arr = NSArray(array: array)

        let rang = NSRange(location: index, length: array.count - index)
        let resul = arr.subarray(with: rang)

        let range = NSRange(location: 0, length: index)
        let result = arr.subarray(with: range)

        return resul + result
    }
}
