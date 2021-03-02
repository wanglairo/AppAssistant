//
//  FPSPlugin.swift
//  AppAssistant
//
//  Created by zhaochangwu on 2020/10/16.
//

struct FPSPlugin: PluginProtocol {

    var module: PluginModule { .performance }

    var title: String { "帧率监控" }

    var icon: String? { "icon_fps" }

    func onInstall() {

    }

    func onSelected() {
        AssistantHomeWindow.openPlugin(AssistantFPSViewController())
    }

}
