//
//  CLLocationManager+Assistant.swift
//  AppAssistant
//
//  Created by wangbao on 2020/10/21.
//

import CoreLocation

extension CLLocationManager {

    @objc
    func assistant_SwizzleLocationDelegate(delegate: AnyObject?) {
        if let delegate = delegate {
            self.assistant_SwizzleLocationDelegate(delegate: AssistantGPSMocker.shareInstance)

            AssistantGPSMocker.shareInstance.addLocationBinder(binder: self, delegate: delegate)

            let proto = objc_getProtocol("CLLocationManagerDelegate")
            if let protoTemp = proto {
                var count: UInt32 = 0
                let startMethod = protocol_copyMethodDescriptionList(protoTemp, false, true, &count)
                let methods = UnsafeMutableBufferPointer(start: startMethod, count: Int(count))
                for index in 0..<count {
                    let sel = methods[Int(index)].name
                    if delegate.responds(to: sel) {
                        if AssistantGPSMocker.shareInstance.responds(to: sel) {

                        }
                    }
                }
//                free(methods)
            }
        } else {
            self.assistant_SwizzleLocationDelegate(delegate: delegate)
        }
    }
}
