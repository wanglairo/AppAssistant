//
//  AssistantCacheManager.swift
//  Alamofire
//
//  Created by 王来 on 2020/10/9.
//

import CoreLocation
import Foundation

class AssistantCacheManager: NSObject {

    enum Key {
        static let loggerSwitch = "doraemon_env_key"
        static let mockGPSSwitch = "doraemon_mock_gps_key"
        static let mockCoordinate = "doraemon_mock_coordinate_key"
        static let fps = "doraemon_fps_key"
        static let cpu = "doraemon_cpu_key"
        static let memory = "doraemon_memory_key"
        static let netFlow = "doraemon_netflow_key"
        static let subThreadUICheck = "doraemon_sub_thread_ui_check_key"
        static let crash = "doraemon_crash_key"
        static let nsLog = "doraemon_nslog_key"
        static let methodUseTime = "doraemon_method_use_time_key"
        static let largeImageDetection = "doraemon_large_image_detection_key"
        static let h5historicalRecord = "doraemon_historical_record"
        static let startTime = "doraemon_start_time_key"
        static let startClass = "doraemon_start_class_key"
        static let anrTrack = "doraemon_anr_track_key"
        static let memoryLeak = "doraemon_memory_leak_key"
        static let memoryLeakAlert = "doraemon_memory_leak_alert_key"
        static let allTest = "doraemon_allTest_window_key"
        static let mockCache = "doraemon_mock_cache_key"
        static let healthStart = "doraemon_health_start_key"
        static let kitManager = "\(assistantKitVersion)_doraemon_kit_manager_key"
    }

    static let shared = AssistantCacheManager()

    private let defaults = UserDefaults.standard

    private var memoryLeakOn = false

    private var firstReadMemoryLeakOn = false

    override init() {
        super.init()
    }

    func saveLoggerSwitch(_ isOn: Bool) {
        defaults.set(isOn, forKey: Key.loggerSwitch)
        defaults.synchronize()
    }

    func loggerSwitch() -> Bool {
        return defaults.bool(forKey: Key.loggerSwitch)
    }

    func saveMockGPSSwitch(_ isOn: Bool) {
        defaults.set(isOn, forKey: Key.mockGPSSwitch)
        defaults.synchronize()
    }

    func mockGPSSwitch() -> Bool {
        return defaults.bool(forKey: Key.mockGPSSwitch)
    }

    func saveMockCoordinate(_ coordinate: CLLocationCoordinate2D) {
        let dict = [
            "longitude": coordinate.longitude,
            "latitude": coordinate.latitude
        ]
        defaults.set(dict, forKey: Key.mockCoordinate)
        defaults.synchronize()
    }

    func mockCoordinate() -> CLLocationCoordinate2D {
        let dict = defaults.dictionary(forKey: Key.mockCoordinate)
        var coordinate = CLLocationCoordinate2D()
        if let longitude = dict?["longitude"] as? CLLocationDegrees {
            coordinate.longitude = longitude
        } else {
            coordinate.longitude = 0
        }
        if let latitude = dict?["latitude"] as? CLLocationDegrees {
            coordinate.latitude = latitude
        } else {
            coordinate.latitude = 0
        }
        return coordinate
    }

    func saveFpsSwitch(_ isOn: Bool) {
        defaults.set(isOn, forKey: Key.fps)
        defaults.synchronize()
    }

    func fpsSwitch() -> Bool {
        return defaults.bool(forKey: Key.fps)
    }

    func saveCpuSwitch(_ isOn: Bool) {
        defaults.setValue(isOn, forKey: Key.cpu)
        defaults.synchronize()
    }

    func cpuSwitch() -> Bool {
        return defaults.bool(forKey: Key.cpu)
    }

    func saveMemorySwitch(_ isOn: Bool) {
        defaults.set(isOn, forKey: Key.memory)
        defaults.synchronize()
    }

    func memorySwitch() -> Bool {
        return defaults.bool(forKey: Key.memory)
    }

    func saveNetFlowSwitch(_ isOn: Bool) {
        defaults.set(isOn, forKey: Key.netFlow)
        defaults.synchronize()
    }

    func netFlowSwitch() -> Bool {
        return defaults.bool(forKey: Key.netFlow)
    }

    func saveAllTestSwitch(_ isOn: Bool) {
        defaults.set(isOn, forKey: Key.allTest)
        defaults.synchronize()
    }

    func allTestSwitch() -> Bool {
        return defaults.bool(forKey: Key.allTest)
    }

    func saveLargeImageDetectionSwitch(_ isOn: Bool) {
        defaults.set(isOn, forKey: Key.largeImageDetection)
        defaults.synchronize()
    }

    func largeImageDetectionSwitch() -> Bool {
        return defaults.bool(forKey: Key.largeImageDetection)
    }

    func saveSubThreadUICheckSwitch(_ isOn: Bool) {
        defaults.set(isOn, forKey: Key.subThreadUICheck)
        defaults.synchronize()
    }

    func subThreadUICheckSwitch() -> Bool {
        return defaults.bool(forKey: Key.subThreadUICheck)
    }

    func saveCrashSwitch(_ isOn: Bool) {
        defaults.set(isOn, forKey: Key.crash)
        defaults.synchronize()
    }

    func crashSwitch() -> Bool {
        return defaults.bool(forKey: Key.crash)
    }

    func saveNSLogSwitch(_ isOn: Bool) {
        defaults.set(isOn, forKey: Key.nsLog)
        defaults.synchronize()
    }

    func nsLogSwitch() -> Bool {
        return defaults.bool(forKey: Key.nsLog)
    }

    func saveMethodUseTimeSwitch(_ isOn: Bool) {
        defaults.set(isOn, forKey: Key.methodUseTime)
        defaults.synchronize()
    }

    func methodUseTimeSwitch() -> Bool {
        return defaults.bool(forKey: Key.methodUseTime)
    }

    func saveStartTimeSwitch(_ isOn: Bool) {
        defaults.set(isOn, forKey: Key.startTime)
        defaults.synchronize()
    }

     func startTimeSwitch() -> Bool {
        return defaults.bool(forKey: Key.startTime)
    }

     func saveANRTrackSwitch(_ isOn: Bool) {
        defaults.set(isOn, forKey: Key.anrTrack)
        defaults.synchronize()
    }

     func anrTrackSwitch() -> Bool {
        return defaults.bool(forKey: Key.anrTrack)
    }

     func h5historicalRecord() -> [String] {
        return defaults.array(forKey: Key.h5historicalRecord) as? [String] ?? []
    }

     func saveH5historicalRecord(withText text: String) {
        if text.isEmpty {
            return
        }
        var records = h5historicalRecord()
        if records.contains(text) {
            if records[0] == text {
                return
            }
            if let index = records.firstIndex(of: text) {
                records.remove(at: index)
            }
        }
        records.insert(text, at: 0)
        if records.count > 10 {
            records.removeLast()
        }
        defaults.set(records, forKey: Key.h5historicalRecord)
        defaults.synchronize()
    }

     func clearAllH5historicalRecord() {
        defaults.removeObject(forKey: Key.h5historicalRecord)
        defaults.synchronize()
    }

     func clearH5historicalRecord(withText text: String) {
        if text.isEmpty {
            return
        }
        var records = h5historicalRecord()
        guard records.contains(text) else {
            return
        }
        if let index = records.firstIndex(of: text) {
            records.remove(at: index)
        }
        if records.isEmpty == false {
            defaults.set(records, forKey: Key.h5historicalRecord)
        } else {
            defaults.removeObject(forKey: Key.h5historicalRecord)
        }
        defaults.synchronize()
    }

     func saveStartClass(_ startClass: String) {
        defaults.set(startClass, forKey: Key.startClass)
        defaults.synchronize()
    }

     func startClass() -> String {
        return defaults.string(forKey: Key.startClass) ?? ""
    }

    // 内存泄漏开关
     func saveMemoryLeak(_ isOn: Bool) {
        defaults.set(isOn, forKey: Key.memoryLeak)
        defaults.synchronize()
    }

     func memoryLeak() -> Bool {
        if firstReadMemoryLeakOn {
            return memoryLeakOn
        }
        firstReadMemoryLeakOn = true
        memoryLeakOn = defaults.bool(forKey: Key.memoryLeak)
        return memoryLeakOn
    }

    // MARK: 内存泄漏弹框开关
     func saveMemoryLeakAlert(_ isOn: Bool) {
        defaults.set(isOn, forKey: Key.memoryLeakAlert)
        defaults.synchronize()
    }

     func memoryLeakAlert() -> Bool {
        return defaults.bool(forKey: Key.memoryLeakAlert)
    }

    // MARK: mockapi本地缓存情况
     func saveMockCache(_ mocks: [Any]) {
        defaults.set(mocks, forKey: Key.mockCache)
        defaults.synchronize()
    }

     func mockCahce() -> [Any] {
        return defaults.array(forKey: Key.mockCache) ?? []
    }

    // MARK: 健康体检开关
     func saveHealthStart(_ isOn: Bool) {
        defaults.set(isOn, forKey: Key.healthStart)
        defaults.synchronize()
    }

     func healthStart() -> Bool {
        return defaults.bool(forKey: Key.healthStart)
    }

    // Kit Manager数据保存 只保存内部数据
     func saveKitManagerData(_ dataArray: [[String: Any]]) {
        var dataArray = [[String: Any]]()
        for dict in dataArray {
            if let moduleName = dict["moduleName"] as? String,
               moduleName == localizedString("通用工具") ||
                moduleName == localizedString("性能工具") ||
                moduleName == localizedString("UI工具") ||
                moduleName == localizedString("平台工具") ||
                moduleName == "Weex" {
                let pluginArray = dict["pluginArray"] ?? [:]
                dataArray.append([
                    "moduleName": moduleName,
                    "pluginArray": pluginArray
                ])
            }
        }
        defaults.set(dataArray, forKey: Key.kitManager)
        defaults.synchronize()
        NotificationCenter.default.post(name: .kitManagerUpdate, object: nil, userInfo: nil)
    }

     func kitManagerData() -> [[String: Any]] {
        return defaults.array(forKey: Key.kitManager) as? [[String: Any]] ?? []
    }

     func kitShowManagerData() -> [[String: Any]] {
        let dataArray = defaults.array(forKey: Key.kitManager) as? [[String: Any]] ?? []

        return dataArray.map { (dict) -> [String: Any] in

            var newDict = dict
            guard let pluginArray = dict["pluginArray"] as? [[String: Any]] else {
                return dict
            }
            newDict["pluginArray"] = pluginArray.filter { (dict) -> Bool in
                let show = dict["show"] as? NSNumber
                return show?.boolValue == true
            }
            return newDict
        }
    }

//     func allKitShowManagerData() -> [[String: Any]] {
//        let dataArray = AssistantManager.shared.dataArray
//        if kitShowManagerData().isEmpty {
//            return dataArray
//        }
//        var newDataArray = [[String: Any]]()
//
//        for dict in dataArray {
//            let moduleName = dict["moduleName"] as? String ?? ""
//            if moduleName == localizedString("通用工具") ||
//                moduleName == localizedString("性能工具") ||
//                moduleName == localizedString("UI工具") ||
//                moduleName == localizedString("平台工具") ||
//                moduleName == "Weex" {
//                continue
//            }
//            let pluginArray = dict["pluginArray"] ?? [:]
//            newDataArray.append([
//                "moduleName": moduleName,
//                "pluginArray": pluginArray
//            ])
//        }
//        newDataArray.append(contentsOf: kitShowManagerData())
//        return newDataArray
//    }
}
