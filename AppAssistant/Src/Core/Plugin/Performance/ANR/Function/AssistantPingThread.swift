//
//  AssistantPingThread.swift
//  AppAssistant
//
//  Created by wangbao on 2020/11/2.
//

import Foundation

class AssistantPingThread: Thread {

    /// 控制ping主线程的信号量
    var semaphore = DispatchSemaphore(value: 0)
    /// 卡顿阈值
    var thresholdValue: Double = 0
    /// 应用是否在活跃状态
    var isApplicationInActive: Bool = true
    /// 主线程是否卡顿
    var mainThreadBlock: Bool = false
    /// 判断是否需要上报
    var reportInfo: String = ""
    /// 每次ping开始的时间，上报延迟时间统计
    var startTimeValue: Double = 0
    /// 卡顿回调
    var handler: AssistantANRTrackerBlock?

    init(with threshold: Double, handlerBlock: @escaping AssistantANRTrackerBlock) {
        self.thresholdValue = threshold
        self.handler = handlerBlock
        super.init()
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(applicationDidBecomeActive),
                                               name: NSNotification.Name.NSExtensionHostDidBecomeActive,
                                               object: nil)
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(applicationDidEnterBackground),
                                               name: NSNotification.Name.NSExtensionHostDidEnterBackground,
                                               object: nil)
    }

    override func main() {
        let verifyBlock = {
            if self.reportInfo.isEmpty == false {
                if self.handler != nil {
                    let responseTimeValue = Double(NSDate().timeIntervalSince1970)
                    let duration = Double(responseTimeValue - self.startTimeValue) * 1000
                    self.handler?(["title": AssistantUtil.dateFormatNow(), "duration": String(format: "%.0f", duration), "content": self.reportInfo])
                }
                self.reportInfo = ""
            }
        }

        while self.isCancelled == false {
            if isApplicationInActive {
                self.mainThreadBlock = true
                self.reportInfo = ""
                self.startTimeValue = Date().timeIntervalSince1970
                DispatchQueue.main.async {
                    self.mainThreadBlock = false
                    verifyBlock()
                    self.semaphore.signal()
                }
                Thread.sleep(forTimeInterval: thresholdValue)
                if self.mainThreadBlock {
                    reportInfo = backtraceMainThread()
                }
                _ = self.semaphore.wait(timeout: .now() + 5)
                verifyBlock()
            } else {
                Thread.sleep(forTimeInterval: thresholdValue)
            }
        }
    }

    deinit {
        NotificationCenter.default.removeObserver(self)
    }

    @objc
    func applicationDidBecomeActive() {
        isApplicationInActive = true
    }

    @objc
    func applicationDidEnterBackground() {
        isApplicationInActive = false
    }

}
