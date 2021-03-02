//
//  ViewMetricsPlugin.swift
//  AppAssistant
//
//  Created by 王来 on 2020/11/10.
//

struct ViewMetricsPlugin: PluginProtocol {

    var module: PluginModule { .uiTool }

    var title: String { "布局边框" }

    var icon: String? { "icon_viewmetrics" }

    func onInstall() {

    }

    func onSelected() {
        ViewMetrics.shared.enable.toggle()
        // toast
        print(ViewMetrics.shared.enable ? "布局边框已开启" : "布局边框已关闭")
    }
}
