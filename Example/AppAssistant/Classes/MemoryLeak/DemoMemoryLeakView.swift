//
//  DemoMemoryLeakView.swift
//  AppAssistant_Example
//
//  Created by 王来 on 2020/11/27.
//  Copyright © 2020 CocoaPods. All rights reserved.
//

import UIKit

class DemoMemoryLeakView: UIView {

    var model: DemoMemoryLeakModel

    override init(frame: CGRect) {
        model = DemoMemoryLeakModel()
        super.init(frame: frame)
        self.backgroundColor = UIColor.orange
        model.closure = { () -> Void in
            self.doSomeThing()
        }
        model.callClosure()
    }

    func doSomeThing() {
        print("view doSomeThing")
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    deinit {
        print("view deinit")
    }

}
