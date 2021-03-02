//
//  UIProfilePlugin.swift
//  AppAssistant
//
//  Created by 王来 on 2020/11/10.
//

struct UIProfilePlugin { }

extension UIProfilePlugin: PluginProtocol {
    var module: PluginModule {
        .uiTool
    }

    var title: String {
        "UI层级"
    }

    var icon: String? {
        "icon_view_level"
    }

    func onInstall() {

        DispatchQueue.once(token: "vc_viewDidAppear") {

            let originalSelector = #selector(UIViewController.viewDidAppear(_:))
            let swizzledSelector = #selector(UIViewController.asskit_viewDidAppear(_:))
            UIViewController.assistant_swizzleInstanceMethodWithOriginSel(oriSel: originalSelector, swiSel: swizzledSelector)
        }

        DispatchQueue.once(token: "vc_viewWillDisappear") {

            let originalSelector = #selector(UIViewController.viewWillDisappear(_:))
            let swizzledSelector = #selector(UIViewController.asskit_viewWillDisappear(_:))
            UIViewController.assistant_swizzleInstanceMethodWithOriginSel(oriSel: originalSelector, swiSel: swizzledSelector)
        }
    }

    func onSelected() {
        AssistantHomeWindow.openPlugin(UIProfileViewController())
    }

}
