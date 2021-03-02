//
//  FPSOscillogramWindow.swift
//  AppAssistant
//
//  Created by zhaochangwu on 2020/10/16.
//

import Foundation

class AssistantFPSOscillogramWindow: AssistantOscillogramWindow {

    private static let fpsSingle = AssistantFPSOscillogramWindow(frame: .zero)

    override class var sharedInstance: AssistantFPSOscillogramWindow {
        return fpsSingle
    }

    override func addRootVC() {
        let vc = AssistantFPSOscillogramViewController()
        self.rootViewController = vc
        self.vc = vc
    }
}
