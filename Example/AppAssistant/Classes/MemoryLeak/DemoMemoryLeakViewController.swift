//
//  DemoMemoryLeakViewController.swift
//  AppAssistant_Example
//
//  Created by 王来 on 2020/11/27.
//  Copyright © 2020 CocoaPods. All rights reserved.
//

import UIKit

class DemoMemoryLeakViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = UIColor.white
        let leakView = DemoMemoryLeakView(frame: CGRect(x: 100, y: 200, width: 100, height: 200))
        view.addSubview(leakView)
    }

    deinit {
        print("vc deinit")
    }
}
