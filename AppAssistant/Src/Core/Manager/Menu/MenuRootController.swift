//
//  MenuRootController.swift
//  AppAssistant
//
//  Created by 王来 on 2020/10/9.
//

import UIKit

extension AssistantMenu.RootController {

    // swiftlint:disable override_in_extension
    override func viewDidLoad() {
        super.viewDidLoad()

        view.addSubview(closeView)
        view.addSubview(basicMenu)

        basicMenu.bounds = CGRect(origin: .zero, size: AssistantMenu.core.config.closeSize)
        basicMenu.center = AssistantMenu.core.config.closeCenter

        basicMenu.bindEvent { (event) in
            switch event {
            case .updated(state: let state):
                switch state {
                case .isOpen:
                    self.closeView.isHidden = false
                case .isClose:
                    self.closeView.isHidden = true
                }
            }
        }
    }

    // swiftlint:disable override_in_extension
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: true)
    }

    // swiftlint:disable override_in_extension
    override func viewDidLayoutSubviews() {
        closeView.frame = view.bounds
    }

}
