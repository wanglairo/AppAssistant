//
//  AssistantANRManager.swift
//  AppAssistant
//
//  Created by wangbao on 2020/11/2.
//

import Foundation

typealias AssistantANRManagerBlock = ([String: Any]) -> Void

class AssistantANRManager: NSObject {

    var assistantANRTracker: AssistantANRTracker?
    var timeOut = 0.2
    var anrTrackOn = false
    var block: AssistantANRManagerBlock?

    static let sharedInstance = AssistantANRManager()

    override init() {
        super.init()

        assistantANRTracker = AssistantANRTracker()
        anrTrackOn = AssistantCacheManager.shared.anrTrackSwitch()
        if anrTrackOn {
            self.start()
        } else {
            self.stop()
        }
    }

    deinit {
        self.stop()
    }

    func start() {
        assistantANRTracker?.startWithThreshold(threshold: timeOut, handler: { [weak self] (info) in
            guard let self = self else {
                return
            }
            self.dumpWithInfo(info: info)
        })
    }

    func dumpWithInfo(info: [String: Any]) {
        DispatchQueue.main.async {
            self.block?(info)
        }
        AssistantANRTool.saveANRInfo(info: info)
    }

    func stop() {
        self.assistantANRTracker?.stop()
    }

    func addANRBlock(block: @escaping AssistantANRManagerBlock) {
        self.block = block
    }

    func setAnrTrackOn(anrTrackValue: Bool) {
        anrTrackOn = anrTrackValue
        AssistantCacheManager.shared.saveANRTrackSwitch(anrTrackOn)
    }
}
