//
//  UIProfileManager.swift
//  AppAssistant
//
//  Created by 王来 on 2020/11/10.
//

struct UIProfileManager {

    static var shared = UIProfileManager()

    var isEnable = false

    func start() {
        UIViewController.topViewControllerForKeyWindow()?.profileViewDepth()
    }

    func stop() {
        UIViewController.topViewControllerForKeyWindow()?.resetProfileData()
        UIProfileWindow.shared.hide()
    }
}
