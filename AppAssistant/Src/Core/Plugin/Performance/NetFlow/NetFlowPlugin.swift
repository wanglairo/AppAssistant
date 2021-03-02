//
//  NetFlowPlugin.swift
//  Alamofire
//
//  Created by 王来 on 2020/10/16.
//

struct NetFlowPlugin: PluginProtocol {

    var module: PluginModule { .performance }

    var title: String { "流量监控" }

    var icon: String? { "icon_net" }

    func onInstall() {

    }

    func onSelected() {
        AssistantHomeWindow.openPlugin(NetFlowViewController())
    }

}
