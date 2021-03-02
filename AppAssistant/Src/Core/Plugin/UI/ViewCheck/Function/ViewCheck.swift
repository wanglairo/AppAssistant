//
//  ViewCheck.swift
//  AppAssistant
//
//  Created by 王来 on 2020/11/10.
//

import UIKit

class ViewCheck {

    static let shared = ViewCheck()

    private weak var view: ViewCheckView?
    private var observation: NSKeyValueObservation?
    private var closeObserver: NSObjectProtocol?

    private init() {
        observation = AssistantUtil.getKeyWindow().observe(\.rootViewController, options: []) { [weak self] (observer, _) in
            guard let self = self else {
                return
            }
            guard let view = self.view else {
                return
            }
            observer.bringSubviewToFront(view)
        }

        closeObserver = NotificationCenter.default.addObserver(
            forName: .closePlugin,
            object: nil,
            queue: .main
        ) { [weak self] (_) in
            self?.hide()
        }
    }

    deinit {
        observation?.invalidate()
        NotificationCenter.default.removeObserver(closeObserver as Any)
    }
}

extension ViewCheck {

    func show() {

        let window = AssistantUtil.getKeyWindow()

        if let view = view {
            window.bringSubviewToFront(view)
            view.reset()

        } else {
            let view = ViewCheckView()
            view.frame = window.bounds
            view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
            window.addSubview(view)
            view.reset()
            self.view = view
        }
    }

    func hide() {
        view?.removeFromSuperview()
    }
}
