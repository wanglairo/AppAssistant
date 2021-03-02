//
//  AssistantNetFlowOscillogramWindow.swift
//  Alamofire
//
//  Created by 王来 on 2020/10/22.
//

import UIKit

class AssistantNetFlowOscillogramWindow: AssistantOscillogramWindow {

    static let shared = AssistantNetFlowOscillogramWindow(frame: .zero)

    override func addRootVC() {
        let vc = AssistantNetFlowOscillogramController()
        self.rootViewController = vc
        self.vc = vc
    }

}
