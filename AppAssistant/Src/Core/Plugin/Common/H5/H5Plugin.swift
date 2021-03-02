//
//  H5Plugin.swift
//  AppAssistant
//
//  Created by 王来 on 2020/10/15.
//

struct H5Plugin: PluginProtocol {

    var module: PluginModule { .common }

    var title: String { "H5任意门" }

    var icon: String? { "icon_h5" }

    func onInstall() {

    }

    func onSelected() {
        AssistantHomeWindow.openPlugin(H5ViewController())
    }

}
