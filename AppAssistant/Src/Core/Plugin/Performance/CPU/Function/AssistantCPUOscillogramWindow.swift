//
//  AssistantCPUOscillogramWindow.swift
//  AppAssistant
//
//  Created by zhaochangwu on 2020/10/15.
//

import Foundation

class AssistantCPUOscillogramWindow: AssistantOscillogramWindow {

    private static let cpuSingle = AssistantCPUOscillogramWindow(frame: .zero)

    override class var sharedInstance: AssistantCPUOscillogramWindow {
        return cpuSingle
    }

    override func addRootVC() {
        let vc = AssistantCPUOscillogramViewController()
        self.rootViewController = vc
        self.vc = vc
    }
}
