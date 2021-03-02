//
//  ViewAlign.swift
//  Alamofire
//
//  Created by 王来 on 2020/11/9.
//

import Foundation

class ViewAlign {

    static let shared = ViewAlign()

    private weak var view: ViewAlignView?
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

extension ViewAlign {

    func show() {

        let window = AssistantUtil.getKeyWindow()

        if let view = view {
            window.bringSubviewToFront(view)
            view.reset()

        } else {
            let view = ViewAlignView()
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
