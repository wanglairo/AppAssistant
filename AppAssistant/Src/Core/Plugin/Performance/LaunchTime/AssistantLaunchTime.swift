//
//  AssistantLaunchTime.swift
//  AppAssistant
//
//  Created by wangbao on 2020/11/5.
//

import UIKit

private var _internalLatency: TimeInterval = 0

struct AssistantLaunchTime {

    fileprivate static var startTime: TimeInterval = 0

    static var latency: TimeInterval {
        get {
            return _internalLatency
        }
        set {
            guard _internalLatency == 0, newValue > 0 else {
                return
            }
            let precision: Double = 1000000
            _internalLatency = floor(newValue * precision) / precision
        }
    }
    // swiftlint:disable discarded_notification_center_observer
    static func addObserver() {
        NotificationCenter.default.addObserver(
            forName: UIApplication.didFinishLaunchingNotification,
            object: nil,
            queue: nil) { _ in
            AssistantLaunchTime.latency = CFAbsoluteTimeGetCurrent() - AssistantLaunchTime.startTime
            AssistantLaunchTime.stopObserver()
        }
    }

    static func stopObserver() {
        NotificationCenter.default.removeObserver(self, name: UIApplication.willResignActiveNotification, object: nil)
    }
}

extension AssistantLaunchTime {
    func onInstall() {
    }
}

extension UIApplication {
    @objc
    dynamic static func applicationLoadHandle() {
        AssistantLaunchTime.startTime = CFAbsoluteTimeGetCurrent()
        AssistantLaunchTime.addObserver()
    }
}
