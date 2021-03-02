//
//  ViewMetricsView.swift
//  AppAssistant
//
//  Created by 王来 on 2020/11/10.
//

import Foundation

private var borderLayerKey: Void?

extension UIView {

    private var borderLayer: CALayer? {
        get { return objc_getAssociatedObject(self, &borderLayerKey) as? CALayer }
        set { objc_setAssociatedObject(self, &borderLayerKey, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC) }
    }

    @objc
    func metrics_layoutSubviews() {
        self.metrics_layoutSubviews()

        recursion(ViewMetrics.shared.enable)
    }

    private func recursion(_ enable: Bool) {
        guard isDescendant(of: AssistantUtil.getKeyWindow()) else {
            return
        }

        subviews.forEach { $0.recursion(enable) }

        if enable {
            if borderLayer == nil {
                let border = CALayer()
                border.borderWidth = 1
                border.borderColor = UIColor.assistant_randomColor().cgColor
                borderLayer = border
                layer.addSublayer(border)
            }
            borderLayer?.frame = bounds
            borderLayer?.isHidden = false

        } else {
            borderLayer?.isHidden = true
        }
    }
}
