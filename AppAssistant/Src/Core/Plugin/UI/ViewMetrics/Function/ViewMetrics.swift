//
//  ViewMetrics.swift
//  AppAssistant
//
//  Created by 王来 on 2020/11/10.
//

class ViewMetrics {

    static let shared = ViewMetrics()

    var enable: Bool = false {
        didSet { AssistantUtil.getKeyWindow().layoutSubviews() }
    }

    private init() {

        DispatchQueue.once(token: "UIView_layoutSubviews") {

            let originalSelector = #selector(UIView.layoutSubviews)
            let swizzledSelector = #selector(UIView.metrics_layoutSubviews)
            UIView.assistant_swizzleInstanceMethodWithOriginSel(oriSel: originalSelector, swiSel: swizzledSelector)
        }
    }
}
