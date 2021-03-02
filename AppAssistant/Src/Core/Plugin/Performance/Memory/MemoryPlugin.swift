//
//  MemoryPlugin.swift
//  AppAssistant
//
//  Created by wangbao on 2020/10/19.
//

struct MemoryPlugin: PluginProtocol {

    var module: PluginModule { .performance }

    var title: String { "内存监控" }

    var icon: String? { "icon_memory" }

    func onInstall() {

    }

    func onSelected() {
        AssistantHomeWindow.openPlugin(AssistantMemoryViewController())
    }

}
