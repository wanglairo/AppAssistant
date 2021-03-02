//
//  AssistantClosedPlugin.swift
//  Alamofire
//
//  Created by wangbao on 2020/11/10.
//

struct AssistantClosedPlugin: PluginProtocol {

    var module: PluginModule { .common }

    var title: String { "关闭小助手" }

    var icon: String? { "icon_close_w" }

    func onInstall() {

    }

    func onSelected() {
        AssistantAlertUtil.handleAlertActionWithVC(
            vc: UIApplication.shared.keyWindow?.rootViewController ?? UIViewController(),
            text: localizedString("重新打开小助手需要重启App才能生效"),
            okBlock: {
                AssistantManager.shared.closeSwitchs()
                AssistantManager.shared.hiddenAssistant()
            },
            cancelBlock: {
            }
        )
    }
}
