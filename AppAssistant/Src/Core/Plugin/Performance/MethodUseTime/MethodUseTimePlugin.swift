//
//  MethodUseTimePlugin.swift
//  Alamofire
//
//  Created by wangbao on 2020/11/10.
//

import Foundation

struct MethodUseTimePlugin: PluginProtocol {

    var module: PluginModule { .performance }

    var title: String { "方法耗时" }

    var icon: String? { "icon_methodusetime" }

    func onInstall() {

    }

    func onSelected() {
        AssistantHomeWindow.openPlugin(AssistantMethodUseTimeViewController())
    }
}
