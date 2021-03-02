//
//  AssistantDefine.swift
//  AppAssistant
//
//  Created by 王来 on 2020/10/9.
//

import Foundation

let assistantKitVersion = "3.0.2"

let screenWidth = UIScreen.main.bounds.size.width
let screenHeight = UIScreen.main.bounds.size.height

// Doraemon默认位置
let startingPosition = CGPoint(x: 0, y: screenHeight / 3.0)
let fullScreenStartingPosition = CGPoint.zero

let isInterfaceOrientationPortrait = UIApplication.shared.statusBarOrientation.isPortrait

let isIPhoneXSeries = AssistantAppInfoUtil.isIPhoneXSeries()

let iPhoneNavigationBarHeight = isIPhoneXSeries ? 88 : 64
let iPhoneStatusBarHeight = isIPhoneXSeries ? 44 : 20
let iPhoneSafebottomAreaHeight = isIPhoneXSeries ? 34 : 0
let iPhoneTopSensorHeight = isIPhoneXSeries ? 32 : 0

extension Notification.Name {

    static let closePlugin = Notification.Name(rawValue: "AssistantClosePluginNotification")

    static let quickOpenLogVC = Notification.Name(rawValue: "AssistantQuickOpenLogVCNotification")

    static let kitManagerUpdate = Notification.Name(rawValue: "AssistantKitManagerUpdateNotification")
}

let navBgImage = UIImage(color: UIColor.white)?.resizableImage(withCapInsets: UIEdgeInsets(top: 1, left: 1, bottom: 1, right: 1), resizingMode: .stretch)
