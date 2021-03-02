//
//  CPUPlugin.swift
//  Alamofire
//
//  Created by wangbao on 2020/10/19.
//

import Foundation

struct CPUPlugin: PluginProtocol {

    var module: PluginModule { .performance }

    var title: String { "CPU监控" }

    var icon: String? { "icon_cpu" }

    func onInstall() {

    }

    func onSelected() {
        AssistantHomeWindow.openPlugin(AssistantCPUViewController())
    }

}
