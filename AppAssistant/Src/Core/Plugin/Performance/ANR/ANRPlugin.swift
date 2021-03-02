//
//  ANRPlugin.swift
//  Alamofire
//
//  Created by wangbao on 2020/11/2.
//

import Foundation

struct ANRPlugin: PluginProtocol {

    var module: PluginModule { .performance }

    var title: String { "卡顿监控" }

    var icon: String? { "icon_anr" }

    func onInstall() {

    }

    func onSelected() {
        AssistantHomeWindow.openPlugin(AssistantANRViewController())
    }

}
