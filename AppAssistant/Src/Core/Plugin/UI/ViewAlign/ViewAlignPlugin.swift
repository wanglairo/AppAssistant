//
//  ViewAlignPlugin.swift
//  Alamofire
//
//  Created by 王来 on 2020/11/9.
//

struct ViewAlignPlugin: PluginProtocol {

    var module: PluginModule { .uiTool }

    var title: String { "对齐标尺" }

    var icon: String? { "icon_align" }

    func onInstall() {

    }

    func onSelected() {
        ViewAlign.shared.show()
        VisualInfo.defalut.show()
    }
}
