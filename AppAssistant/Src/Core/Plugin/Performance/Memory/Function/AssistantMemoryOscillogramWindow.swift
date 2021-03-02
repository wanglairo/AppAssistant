//
//  AssistantMemoryOscillogramWindow.swift
//  Alamofire
//
//  Created by wangbao on 2020/10/15.
//

import Foundation

class AssistantMemoryOscillogramWindow: AssistantOscillogramWindow {

    private static let memorySingle = AssistantMemoryOscillogramWindow(frame: .zero)

    override class var sharedInstance: AssistantMemoryOscillogramWindow {
        return memorySingle
    }

    override func addRootVC() {
        let vc = AssistantMemoryOscillogramViewController()
        self.rootViewController = vc
        self.vc = vc
    }
}
