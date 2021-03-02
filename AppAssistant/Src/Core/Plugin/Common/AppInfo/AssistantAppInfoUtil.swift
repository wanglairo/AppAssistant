//
//  AssistantAppInfoUtil.swift
//  AppAssistant
//
//  Created by wangbao on 2020/9/30.
//

import AddressBook
import AssetsLibrary
import AVFoundation
import Contacts
import CoreLocation
import EventKit
import Foundation
import Photos

let IOSCELLULAR = "pdp_ip0"
let IOSWIFI = "en0"
let IPADDRIPv4 = "ipv4"
let IPADDRIPv6 = "ipv6"

class AssistantAppInfoUtil: NSObject {

    static func appName() -> String {
        var appName = Bundle.main.infoDictionary?["CFBundleDisplayName"]
        if appName == nil {
            appName = Bundle.main.infoDictionary?["CFBundleName"]
        }
        return appName as? String ?? ""
    }

    static func iphoneName() -> String {
        return UIDevice.current.name
    }

    static func iphoneSystemVersion() -> String {
        return UIDevice.current.systemVersion
    }

    static func bundleIdentifier() -> String {
        return Bundle.main.bundleIdentifier ?? ""
    }

    static func bundleVersion() -> String {
        let version = Bundle.main.infoDictionary?["CFBundleVersion"]
        return version as? String ?? ""
    }

    static func bundleShortVersionString() -> String {
        let versionString = Bundle.main.infoDictionary?["CFBundleShortVersionString"]
        return versionString as? String ?? ""
    }

    // swiftlint:disable cyclomatic_complexity
    // swiftlint:disable function_body_length
    static func iphoneType() -> String {

        var systemInfo = utsname()
        uname(&systemInfo)
        let machineMirror = Mirror(reflecting: systemInfo.machine)

        let platform = machineMirror.children.reduce(into: "") { (platform, element) in
            if let value = element.value as? Int8, value != 0 {
                platform += String(UnicodeScalar(UInt8(value)))
            }
        }
        // iPhone
        if platform == "iPhone1,1" {
            return "iPhone 1G"
        } else if platform == "iPhone1,2" {
            return "iPhone 3G"
        } else if platform == "iPhone2,1" {
            return "iPhone 3GS"
        } else if platform == "iPhone3,1" {
            return "iPhone 4"
        } else if platform == "iPhone3,2" {
            return "iPhone 4"
        } else if platform == "iPhone4,1" {
            return "iPhone 4S"
        } else if platform == "iPhone5,1" {
            return "iPhone 5"
        } else if platform == "iPhone5,2" {
            return "iPhone 5"
        } else if platform == "iPhone5,3" {
            return "iPhone 5C"
        } else if platform == "iPhone5,4" {
            return "iPhone 5C"
        } else if platform == "iPhone6,1" {
            return "iPhone 5S"
        } else if platform == "iPhone6,2" {
            return "iPhone 5S"
        } else if platform == "iPhone7,1" {
            return "iPhone 6 Plus"
        } else if platform == "iPhone7,2" {
            return "iPhone 6"
        } else if platform == "iPhone8,1" {
            return "iPhone 6S"
        } else if platform == "iPhone8,2" {
            return "iPhone 6S Plus"
        } else if platform == "iPhone8,4" {
            return "iPhone SE"
        } else if platform == "iPhone9,1" {
            return "iPhone 7"
        } else if platform == "iPhone9,3" {
            return "iPhone 7"
        } else if platform == "iPhone9,2" {
            return "iPhone 7 Plus"
        } else if platform == "iPhone9,4" {
            return "iPhone 7 Plus"
        } else if platform == "iPhone10,1" {
            return "iPhone 8"
        } else if platform == "iPhone10.4" {
            return "iPhone 8"
        } else if platform == "iPhone10,2" {
            return "iPhone 8 Plus"
        } else if platform == "iPhone10,5" {
            return "iPhone 8 Plus"
        } else if platform == "iPhone10,3" {
            return "iPhone X"
        } else if platform == "iPhone10,6" {
            return "iPhone X"
        } else if platform == "iPhone11,8" {
            return "iPhone XR"
        } else if platform == "iPhone11,2" {
            return "iPhone XS"
        } else if platform == "iPhone11,4" {
            return "iPhone XS Max"
        } else if platform == "iPhone11,6" {
            return "iPhone XS Max"
        } else if platform == "iPhone12,1" {
            return "iPhone 11"
        } else if platform == "iPhone12,3" {
            return "iPhone 11 Pro"
        } else if platform == "iPhone12,5" {
            return "iPhone 11 Pro Max"
        } else if platform == "iPhone13,1" {
            return "iPhone 12 Mini"
        } else if platform == "iPhone13,2" {
            return "iPhone 12"
        } else if platform == "iPhone13,3" {
            return "iPhone 12 Pro"
        } else if platform == "iPhone13,4" {
            return "iPhone 12 Pro Max"
        }
        return platform
    }

    static func isIPhoneXSeries() -> Bool {
        var iPhoneXSeries = false
        if UIDevice.current.userInterfaceIdiom != .phone {
            return iPhoneXSeries
        }
        if #available(iOS 11.0, *) {
            let mainWindow = AssistantUtil.getKeyWindow()
            if mainWindow.safeAreaInsets.bottom > 0.0 {
                iPhoneXSeries = true
            }
        }
        return iPhoneXSeries
    }

    static func isIpad() -> Bool {
        let deviceType = UIDevice.current.model
        if deviceType == "iPad" {
            return true
        }
        return false
    }

    static func locationAuthority() -> String {
        var authority = ""
        if CLLocationManager.locationServicesEnabled() {
            let state = CLLocationManager.authorizationStatus()
            if state == .notDetermined {
                authority = "NotDetermined"
            } else if state == .restricted {
                authority = "Restricted"
            } else if state == .denied {
                authority = "Denied"
            } else if state == .authorizedAlways {
                authority = "Always"
            } else if state == .authorizedWhenInUse {
                authority = "WhenInUse"
            }
        } else {
            authority = "NoEnabled"
        }
        return authority
    }

    static func pushAuthority() -> String {
        guard let settings = UIApplication.shared.currentUserNotificationSettings else {
            return "false"
        }
        if settings.types == UIUserNotificationType(rawValue: 0) {
            return "false"
        }
        return "true"
    }

    static func cameraAuthority() -> String {
        var authority = ""
        let authStatus = AVCaptureDevice.authorizationStatus(for: .video) // 读取设备授权状态
        switch authStatus {
        case .notDetermined:
            authority = "NotDetermined"
        case .restricted:
            authority = "Restricted"
        case .denied:
            authority = "Denied"
        case .authorized:
            authority = "Authorized"
        default:
            break
        }
        return authority
    }

    static func audioAuthority() -> String {
        var authority = ""
        let authStatus = AVCaptureDevice.authorizationStatus(for: .audio) // 读取设备授权状态
        switch authStatus {
        case .notDetermined:
            authority = "NotDetermined"
        case .restricted:
            authority = "Restricted"
        case .denied:
            authority = "Denied"
        case .authorized:
            authority = "Authorized"
        default:
            break
        }
        return authority
    }

    static func photoAuthority() -> String {
        var authority = ""
        if #available(iOS 8.0, *) {
            let current = PHPhotoLibrary.authorizationStatus()
            switch current {
            case .notDetermined:    // 用户还没有选择(第一次)
                authority = "NotDetermined"
            case .restricted:       // 家长控制
                authority = "Restricted"
            case .denied:           // 用户拒绝
                authority = "Denied"
            case .authorized:       // 已授权
                authority = "Authorized"
            default:
                break
            }
        } else {
            let status = ALAssetsLibrary.authorizationStatus()
            switch status {
            case .notDetermined:
                authority = "NotDetermined"
            case .restricted:
                authority = "Restricted"
            case .denied:
                authority = "Denied"
            case .authorized:
                authority = "Authorized"
            default:
                break
            }
        }
        return authority
    }

    static func addressAuthority() -> String {
        var authority = ""
        if #available(iOS 9.0, *) { // iOS9.0之后
            let authStatus = CNContactStore.authorizationStatus(for: .contacts)
            switch authStatus {
            case .authorized:
                authority = "Authorized"
            case .denied:
                authority = "Denied"
            case .notDetermined:
                authority = "NotDetermined"
            case .restricted:
                authority = "Restricted"
            default:
                break
            }
        } else {// iOS9.0之前
                let authorStatus = ABAddressBookGetAuthorizationStatus()
                switch authorStatus {
                case .authorized:
                    authority = "Authorized"
                case .denied:
                    authority = "Denied"
                case .notDetermined:
                    authority = "NotDetermined"
                case .restricted:
                    authority = "Restricted"
                default:
                    break
                }
            }
        return authority
    }

    static func calendarAuthority() -> String {
        var authority = ""
        let status = EKEventStore.authorizationStatus(for: .event)
        switch status {
        case .notDetermined:
            authority = "NotDetermined"
        case .restricted:
            authority = "Restricted"
        case .denied:
            authority = "Denied"
        case .authorized:
            authority = "Authorized"
        default:
            break
        }
        return authority
    }

    static func remindAuthority() -> String {
        var authority = ""
        let status = EKEventStore.authorizationStatus(for: .reminder)
        switch status {
        case .notDetermined:
            authority = "NotDetermined"
        case .restricted:
            authority = "Restricted"
        case .denied:
            authority = "Denied"
        case .authorized:
            authority = "Authorized"
        default:
            break
        }
        return authority
    }

    static func bluetoothAuthority() -> String {
        return ""
    }

    static func isSimulator() -> Bool {
        var isSim = false
        #if arch(i386) || arch(x86_64)
        isSim = true
        #endif
        return isSim
    }

    // 获取设备当前网络IP地址
    static func getIPAddress(_ preferIPv4: Bool) -> String {
        let searchArray: [String] =
            preferIPv4 ? ["en0/ipv4", "en0/ipv6", "pdp_ip0/ipv4", "pdp_ip0/ipv6"] : ["en0/ipv6", "en0/ipv4", "pdp_ip0/ipv6", "pdp_ip0/ipv4"]
        let addresses: [String: String] = self.getIPAddresses()
        var address = String()
        searchArray.forEach { (item) in
            if address.isEmpty == true {
                address = addresses[item] ?? ""
            }
        }
        return address.isEmpty == false ? address : "0.0.0.0"
    }

    // 获取所有相关IP信息
    static func getIPAddresses() -> [String: String] {
        let addresses = NSMutableDictionary(capacity: 8)
        var interfaces: UnsafeMutablePointer<ifaddrs>?
        if getifaddrs(&interfaces) == 0 {
            // Loop through linked list of interfaces
            for interface in sequence(first: interfaces, next: { $0?.pointee.ifa_next }) {

                if (Int32(interface?.pointee.ifa_flags ?? 0) & IFF_UP) == 0 {
                    continue
                }
                let addrTmp = interface?.pointee.ifa_addr
                if let addr = addrTmp {
                    let addrIn = UnsafeMutablePointer(mutating: addr).withMemoryRebound(to: sockaddr_in.self, capacity: 1) { return $0 }
                    var addrBuf = [CChar](repeating: 0, count: Int(NI_MAXHOST))
                    if addrIn.pointee.sin_family == UInt8(AF_INET) || addrIn.pointee.sin_family == UInt8(AF_INET6) {
                        if let ifaName = interface?.pointee.ifa_name {
                            let name = String(utf8String: ifaName) ?? ""
                            var type = String()
                            if addrIn.pointee.sin_family == UInt8(AF_INET) {
                                if inet_ntop(AF_INET, &(addrIn.pointee.sin_addr), &addrBuf, socklen_t(INET_ADDRSTRLEN)) != nil {
                                    type = IPADDRIPv4
                                }
                            } else {
                                let addr6 = UnsafeMutablePointer(mutating: addr).withMemoryRebound(to: sockaddr_in6.self, capacity: 1) { return $0 }
                                if inet_ntop(AF_INET6, &(addr6.pointee.sin6_addr), &addrBuf, socklen_t(INET6_ADDRSTRLEN)) != nil {
                                    type = IPADDRIPv6
                                }
                            }
                            if type.isEmpty == false {
                                let key: String = "\(name)/\(type)"
                                addresses[key] = String(utf8String: addrBuf)
                            }
                        }
                    }
                }
            }
            // Free memory
            freeifaddrs(interfaces)
        }
        return addresses as? [String: String] ?? ["": ""]
    }

}
