//
//  AssistantFitLayout.swift
//  AppAssistant
//
//  Created by zhaochangwu on 2020/10/15.
//

import Foundation

protocol FitLayout {

    var fitSizeFrom750: CGFloat { get }

    var fitSizeFrom750Landscape: CGFloat { get }
}

// 根据750*1334分辨率计算size
private extension FitLayout {

    var widthRate: Float {

        return Float(screenWidth) / 750.0
    }

    var widthRateLandscape: Float {

        return Float(screenHeight) / 750.0
    }
}

private extension FitLayout {

    func fit<Target>(target: Target, rate: Float) -> CGFloat where Target: BinaryFloatingPoint {

        return CGFloat(ceilf(Float(target) * rate))
    }

    func fit<Target>(target: Target, rate: Float) -> CGFloat where Target: BinaryInteger {

        return CGFloat(ceilf(Float(target) * rate))
    }
}

extension BinaryFloatingPoint where Self: FitLayout {

    var fitSizeFrom750: CGFloat {

        return fit(target: self, rate: widthRate)
    }

    var fitSizeFrom750Landscape: CGFloat {
        return fit(target: self, rate: widthRateLandscape)
    }
}

extension BinaryInteger where Self: FitLayout {

    var fitSizeFrom750: CGFloat {

        return fit(target: self, rate: widthRate)
    }

    var fitSizeFrom750Landscape: CGFloat {
        if isInterfaceOrientationPortrait {
            return fit(target: self, rate: widthRate)
        }
        return fit(target: self, rate: widthRateLandscape)
    }
}

extension Int: FitLayout { }

extension Float: FitLayout { }

extension Double: FitLayout { }

extension CGFloat: FitLayout { }
