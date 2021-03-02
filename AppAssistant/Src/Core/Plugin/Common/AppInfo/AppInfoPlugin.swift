//
//  AppInfoPlugin.swift
//  AppAssistant
//
//  Created by 王来 on 2020/10/15.
//

struct AppInfoPlugin: PluginProtocol {

    var module: PluginModule { .common }

    var title: String { "App信息" }

    var icon: String? { "icon_app_info" }

    func onInstall() {

    }

    func onSelected() {
        AssistantHomeWindow.openPlugin(AssistantAppInfoViewController())
    }

}
