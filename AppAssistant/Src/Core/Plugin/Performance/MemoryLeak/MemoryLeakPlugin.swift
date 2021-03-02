//
//  MemoryLeakPlugin.swift
//  AppAssistant
//
//  Created by 王来 on 2020/11/20.
//

struct MemoryLeakPlugin: PluginProtocol {

    var module: PluginModule { .performance }

    var title: String { "内存泄漏" }

    var icon: String? { "icon_memory" }

    func onInstall() {

    }

    func onSelected() {
        AssistantHomeWindow.openPlugin(MLeaksFinderViewController())
    }

}
