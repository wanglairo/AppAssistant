//
//  GPSPlugin.swift
//  AppAssistant
//
//  Created by wangbao on 2020/10/19.
//

import Foundation

struct GPSPlugin: PluginProtocol {

    var module: PluginModule { .common }

    var title: String { "模拟定位" }

    var icon: String? { "icon_mock_gps" }

    func onInstall() {

    }

    func onSelected() {
        AssistantHomeWindow.openPlugin(AssistantGPSViewController())
    }

}
