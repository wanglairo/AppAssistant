//
//  UIView+Assistant.swift
//  AppAssistant
//
//  Created by zhaochangwu on 2020/10/15.
//

import Foundation

extension UIView: AssistantKitWrappable {}

private let screenScale = UIScreen.main.scale

private func pixelIntegral(_ pointValue: CGFloat) -> CGFloat {
    return (round(pointValue * screenScale) / screenScale)
}

extension AssistantKit where T: UIView {

    /// Origin of view.
    var origin: CGPoint {
        get {
            return base.frame.origin
        }
        set {
            base.assk.x = newValue.x
            base.assk.y = newValue.y
        }
    }

    /// Size of view.
    var size: CGSize {
        get {
            return base.frame.size
        }
        set {
            base.assk.width = newValue.width
            base.assk.height = newValue.height
        }
    }

    var right: CGFloat {
        get {
            return base.frame.origin.x + base.frame.size.width
        }
        set {
            base.assk.x = newValue - base.assk.width
        }
    }

    var left: CGFloat {
        get {
            return base.assk.x
        }
        set {
            base.assk.x = newValue
        }
    }

    var top: CGFloat {
        get {
            return base.assk.y
        }
        set {
            base.assk.y = newValue
        }
    }

    var bottom: CGFloat {
        get {
            return base.frame.origin.y + base.frame.size.height
        }
        set {
            base.assk.y = newValue - base.assk.height
        }
    }

    var centerX: CGFloat {
        get {
            return base.center.x
        }
        set {
            base.center.x = pixelIntegral(newValue)
        }
    }

    var centerY: CGFloat {
        get {
            return base.center.y
        }
        set {
            base.center.y = pixelIntegral(newValue)
        }
    }

    /// Height of view.
    var height: CGFloat {
        get {
            return base.frame.size.height
        }
        set {
            base.frame.size.height = pixelIntegral(newValue)
        }
    }

    /// Width of view.
    var width: CGFloat {
        get {
            return base.frame.size.width
        }
        set {
            base.frame.size.width = pixelIntegral(newValue)
        }
    }

    // swiftlint:disable superfluous_disable_command
    /// x origin of view.
    var x: CGFloat {
        get {
            return base.frame.origin.x
        }
        set {
            base.frame.origin.x = pixelIntegral(newValue)
        }
    }
    // swiftlint:enable identifier_name

    // swiftlint:disable identifier_name
    // swiftlint:disable superfluous_disable_command
    /// y origin of view.
    var y: CGFloat {
        get {
            return base.frame.origin.y
        }
        set {
            base.frame.origin.y = pixelIntegral(newValue)
        }
    }
    // swiftlint:enable identifier_name
}

extension AssistantKit where T: UIView {

    /// Set some or all corners radiuses of view.
    ///
    /// - Parameters:
    ///   - corners: array of corners to change (example: [.bottomLeft, .topRight]).
    ///   - radius: radius for selected corners.
    func roundCorners(_ corners: UIRectCorner, radius: CGFloat) {
        let maskPath = UIBezierPath(
            roundedRect: base.bounds,
            byRoundingCorners: corners,
            cornerRadii: CGSize(width: radius, height: radius))

        let shape = CAShapeLayer()
        shape.path = maskPath.cgPath
        base.layer.mask = shape
    }

    func addShadow(color: UIColor, offsetY: CGFloat, cornorRadius: CGFloat) {
        base.layer.shadowOffset = CGSize(width: 0, height: offsetY)
        base.layer.shadowOpacity = 12
        base.layer.shadowColor = color.cgColor
        base.layer.shadowRadius = cornorRadius
    }
}

extension AssistantKit where T: UIView {

    /// Get view's parent view controller
    var parentViewController: UIViewController? {
        weak var parentResponder: UIResponder? = base
        while parentResponder != nil {
            parentResponder = parentResponder?.next
            if let viewController = parentResponder as? UIViewController {
                return viewController
            }
        }
        return nil
    }
}
