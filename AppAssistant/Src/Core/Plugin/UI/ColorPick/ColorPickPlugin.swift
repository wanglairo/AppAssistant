//
//  ColorPickPlugin.swift
//  AppAssistant
//
//  Created by 王来 on 2020/11/10.
//

struct ColorPickPlugin: PluginProtocol {

    var module: PluginModule { .uiTool }

    var title: String { "取色器" }

    var icon: String? { "icon_straw" }

    func onInstall() {

    }
    func onSelected() {
        ColorPickWindow.shared.show()
        VisualInfo.colorPick.show()
    }
}
