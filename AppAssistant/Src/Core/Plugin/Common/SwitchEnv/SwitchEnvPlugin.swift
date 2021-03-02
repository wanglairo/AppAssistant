//
//  SwitchEnvPlugin.swift
//  AppAssistant
//
//  Created by 王来 on 2020/10/14.
//

struct SwitchEnvPlugin: PluginProtocol {

    var module: PluginModule { .common }

    var title: String { "环境切换" }

    var icon: String? { "icon_switchenv" }

    func onInstall() {

    }

    func onSelected() {
        let vc = EnvironmentViewController()
        vc.dataArray = [["title": "选择环境", "array": AssistantManager.shared.env.map { [ "title": $0] }]]
        AssistantHomeWindow.openPlugin(vc)
    }

}
