//
//  DemoMemoryLeakModel.swift
//  AppAssistant_Example
//
//  Created by 王来 on 2020/11/27.
//  Copyright © 2020 CocoaPods. All rights reserved.
//

import UIKit

class DemoMemoryLeakModel: NSObject {

    var closure: (() -> Void)?

    func callClosure() {
        closure?()
    }

    deinit {
        print("model deinit")
    }
}
