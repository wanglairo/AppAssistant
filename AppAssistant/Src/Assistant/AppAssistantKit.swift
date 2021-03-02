//
//  AppAssistantKit.swift
//  AppAssistant
//
//  Created by 王来 on 2020/9/29.
//

import Foundation

public class AppAssistantKit {

    init() {
    }

    /// 初始化(默认显示入口)
    public static func install() {
        AssistantManager.shared.install()
    }

    /// 显示入口
    public static func showAssistant() {
        AssistantManager.shared.showAssistant()
    }

    /// 隐藏入口
    public static func hiddenAssistant() {
        AssistantManager.shared.hiddenAssistant()
    }

    /// 入口的显示状态
    public static func isShowAssistant() {
        AssistantManager.shared.isShowAssistant()
    }

    /// 注册环境切换控制器
    public static func registerEnv(_ env: [String], switchAction: @escaping (String) -> Void) {
        AssistantManager.shared.registerEnv(env, switchAction: switchAction)
    }

    /// 注册环境切换控制器
    public static func registerOpenWebView(block: @escaping (String, UINavigationController?) -> Void) {
        AssistantManager.shared.registerOpenWebView(block: block)
    }
}
