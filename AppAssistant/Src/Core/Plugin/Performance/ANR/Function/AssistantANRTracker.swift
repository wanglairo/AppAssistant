//
//  AssistantANRTracker.swift
//  AppAssistant
//
//  Created by wangbao on 2020/11/2.
//

import Foundation

enum AssistantANRTrackerStatus {
    // 监控开启
    case start
    // 监控停止
    case stop
}

typealias AssistantANRTrackerBlock = ([String: Any]) -> Void

class AssistantANRTracker: NSObject {

    var pingThread: AssistantPingThread?

    func startWithThreshold(threshold: Double, handler: @escaping AssistantANRTrackerBlock) {
        pingThread = AssistantPingThread(with: threshold, handlerBlock: { (info) in
            handler(info)
        })
        pingThread?.start()
    }

    func status() -> AssistantANRTrackerStatus {
        if self.pingThread != nil && self.pingThread?.isCancelled != true {
            return .start
        } else {
            return .stop
        }
    }

    func stop() {
        if self.pingThread != nil {
            self.pingThread?.cancel()
            self.pingThread = nil
        }
    }

    deinit {
        self.pingThread?.cancel()
    }
}
