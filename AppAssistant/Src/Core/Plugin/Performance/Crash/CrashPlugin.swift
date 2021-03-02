//
//  CrashPlugin.swift
//  AppAssistant
//
//  Created by 王来 on 2020/11/17.
//

import Foundation

struct CrashPlugin: PluginProtocol {

    var module: PluginModule { .performance }

    var title: String { "Crash" }

    var icon: String? { "icon_crash" }

    func onInstall() {

    }

    func onSelected() {
        AssistantHomeWindow.openPlugin(CrashViewController())
    }

}
