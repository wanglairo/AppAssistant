//
//  AssistantMemoryUtil.swift
//  Alamofire
//
//  Created by wangbao on 2020/10/15.
//

import Foundation

class AssistantMemoryUtil: NSObject {
    // 当前app内存使用量
    static func useMemoryForApp() -> Int {
        var vmInfo = mach_task_basic_info()
        var count = mach_msg_type_number_t(MemoryLayout<mach_task_basic_info>.size)
        let kernelReturn = withUnsafeMutablePointer(to: &vmInfo) {
            $0.withMemoryRebound(to: integer_t.self, capacity: 1) {
                 task_info(mach_task_self_, task_flavor_t(MACH_TASK_BASIC_INFO), $0, &count)
            }
        }
        if kernelReturn == KERN_SUCCESS {
            return Int(vmInfo.resident_size / 1024 / 1024)
        } else {
            return -1
        }
    }
    // 设备总的内存
    static func totalMemoryForDevice() -> Int {
        return Int(ProcessInfo.processInfo.physicalMemory / 1024 / 1024)
    }
}
