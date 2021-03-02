//
//  ViewCheckPlugin.swift
//  AppAssistant
//
//  Created by 王来 on 2020/11/10.
//

import Foundation

struct ViewCheckPlugin: PluginProtocol {

    var module: PluginModule { .uiTool }

    var title: String { "组件检查" }

    var icon: String? { "icon_view_check" }

    func onInstall() {

    }

    func onSelected() {
        ViewCheck.shared.show()
        VisualInfo.defalut.show()
        VisualInfo.defalut.frame = VisualInfo.rect
    }
}

fileprivate extension VisualInfo {

    static var rect: CGRect {
        let height: CGFloat = 180.fitSizeFrom750Landscape
        let margin: CGFloat = 30.fitSizeFrom750Landscape
        switch isInterfaceOrientationPortrait {
        case true:
            return .init(
                x: margin,
                y: screenHeight - height - margin - CGFloat(iPhoneSafebottomAreaHeight),
                width: screenWidth - 2 * margin,
                height: height
            )

        case false:
            return .init(
                x: margin,
                y: screenHeight - height - margin - CGFloat(iPhoneSafebottomAreaHeight),
                width: screenHeight - 2 * margin,
                height: height
            )
        }
    }
}
