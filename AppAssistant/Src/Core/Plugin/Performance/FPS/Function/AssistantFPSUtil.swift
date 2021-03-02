//
//  FPSUtil.swift
//  AppAssistant
//
//  Created by zhaochangwu on 2020/10/16.
//

import Foundation

class AssistantFPSUtil: NSObject {

    private var link: CADisplayLink?

    private var count = 0

    private var lastTime: TimeInterval = 0

    private var isStart = false

    private var fps: Int = 0

    private var block: ((Int) -> Void)?

    func start() {
        if let link = link {
            link.isPaused = false
        } else {
            link = CADisplayLink(target: self, selector: #selector(trigger(link:)))
            link?.add(to: RunLoop.main, forMode: .common)
        }
    }

    func end() {
        link?.isPaused = true
        link?.invalidate()
        link = nil
        lastTime = 0
        count = 0
    }

    func addFPSBlock(_ block: @escaping (Int) -> Void) {
        self.block = block
    }

    @objc
    private func trigger(link: CADisplayLink) {
        if lastTime == 0 {
            lastTime = link.timestamp
            return
        }
        count += 1
        let delta = link.timestamp - lastTime
        if delta < 1 {
            return
        }
        lastTime = link.timestamp
        let fps = Double(count) / delta
        count = 0
        let intFPS = Int(fps + 0.5)
        self.fps = intFPS
        if self.block != nil {
            self.block?(intFPS)
        }
    }
}
