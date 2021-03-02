//
//  LaunchTimePlugin.swift
//  Alamofire
//
//  Created by wangbao on 2020/11/5.
//

import Foundation

struct LaunchTimePlugin: PluginProtocol {

    var module: PluginModule { .performance }

    var title: String { "启动耗时" }

    var icon: String? { "icon_launchtime" }

    func onInstall() {

    }

    func onSelected() {
        AssistantHomeWindow.openPlugin(AssinstantLaunchTimeViewController())
    }
}
