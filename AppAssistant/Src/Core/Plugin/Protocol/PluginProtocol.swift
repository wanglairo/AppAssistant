//
//  PluginProtocol.swift
//  AppAssistant
//
//  Created by 王来 on 2020/10/14.
//

protocol PluginProtocol {

    var module: PluginModule { get }
    var title: String { get }
    var icon: String? { get }

    /// 当组件被安装时调用
    func onInstall()
    /// 当组件在主页面被选中时调用
    func onSelected()

}

struct DefaultPlugin: PluginProtocol {

    var module: PluginModule
    var title: String
    var icon: String?
    var onInstallClosure: (() -> Void)?
    var onSelectedClosure: (() -> Void)?

    func onInstall() {
        self.onInstallClosure?()
    }
    func onSelected() {
        self.onSelectedClosure?()
    }
}

struct PluginModule: Hashable {
    let name: String
    let icon: String

    init(name: String, icon: String) {
        self.name = name
        self.icon = icon
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(name)
    }
}

extension PluginModule {
    static let common = PluginModule(name: "常用工具", icon: "icon_commontool")
    static let performance = PluginModule(name: "性能检测", icon: "icon_performancetool")
    static let uiTool = PluginModule(name: "视觉工具", icon: "icon_uitool")
}
