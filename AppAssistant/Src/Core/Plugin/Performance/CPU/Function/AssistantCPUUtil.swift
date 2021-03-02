//
//  AssistantCPUUtil.swift
//  AppAssistant
//
//  Created by zhaochangwu on 2020/10/13.
//

import MachO
import UIKit

class AssistantCPUUtil: NSObject {

//    static func cpuUsageForApp() -> CGFloat {
//
//        var kr: kern_return_t
//        var thread_list: thread_array_t?
//        var thread_count: mach_msg_type_number_t = 0
//        var thread_info_count: mach_msg_type_number_t
//        var basic_info_th: thread_basic_info_t
//        var thinfo: [integer_t]
//
//        // get threads in the task
//        //  获取当前进程中 线程列表
//        kr = task_threads(mach_task_self_, &thread_list, &thread_count)
//        if kr != KERN_SUCCESS {
//            return -1
//        }
//
//        guard let thread_list_t = thread_list else {
//            return -1
//        }
//
//        var tot_cpu: Float = 0
//
//        for j in 0..<thread_count {
//            thread_info_count = mach_msg_type_number_t(THREAD_INFO_MAX)
//            thinfo = [integer_t](repeating: 0, count: Int(thread_info_count))
//            //获取每一个线程信息
//            kr = thread_info(thread_list_t[Int(j)], thread_flavor_t(THREAD_BASIC_INFO), &thinfo, &thread_info_count)
//
//            if kr != KERN_SUCCESS {
//                return -1
//            }
//
//            basic_info_th = withUnsafeMutablePointer(to: &thinfo) {
//                $0.withMemoryRebound(to: thread_basic_info_t.self, capacity: MemoryLayout<thread_basic_info_t>.stride) {
//                    $0
//                }
//            }.pointee
//
//            if (Int(basic_info_th.pointee.flags) & Int(TH_FLAGS_IDLE)) == 0 {
//                // cpu_usage : Scaled cpu usage percentage. The scale factor is TH_USAGE_SCALE.
//                //宏定义TH_USAGE_SCALE返回CPU处理总频率：
//                tot_cpu += Float(basic_info_th.pointee.cpu_usage) / Float(TH_USAGE_SCALE)
//            }
//        } // for each thread
//
//
//        // 注意方法最后要调用 vm_deallocate，防止出现内存泄漏
//        let address = withUnsafeMutablePointer(to: &thread_list) {
//            $0.withMemoryRebound(to: vm_address_t.self, capacity: MemoryLayout<vm_address_t>.stride) {
//                $0
//            }
//        }
//        kr = vm_deallocate(mach_task_self_, address.pointee, UInt(thread_count) * UInt(MemoryLayout<thread_t>.stride));
//        assert(kr == KERN_SUCCESS);
//
//        if (tot_cpu < 0) {
//            tot_cpu = 0
//        }
//
//        return CGFloat(tot_cpu);
//    }

    static func cpuUsage() -> Double {
        var totalUsageOfCPU: Double = 0.0
        var threadsList: thread_act_array_t?
        var threadsCount = mach_msg_type_number_t(0)
        let threadsResult = withUnsafeMutablePointer(to: &threadsList) {
            return $0.withMemoryRebound(to: thread_act_array_t?.self, capacity: 1) {
                task_threads(mach_task_self_, $0, &threadsCount)
            }
        }

        if threadsResult == KERN_SUCCESS, let threadsList = threadsList {
            for index in 0..<threadsCount {
                var threadInfo = thread_basic_info()
                var threadInfoCount = mach_msg_type_number_t(THREAD_INFO_MAX)
                let infoResult = withUnsafeMutablePointer(to: &threadInfo) {
                    $0.withMemoryRebound(to: integer_t.self, capacity: 1) {
                        thread_info(threadsList[Int(index)], thread_flavor_t(THREAD_BASIC_INFO), $0, &threadInfoCount)
                    }
                }

                guard infoResult == KERN_SUCCESS else {
                    break
                }

                let threadBasicInfo = threadInfo as thread_basic_info
                if threadBasicInfo.flags & TH_FLAGS_IDLE == 0 {
                    totalUsageOfCPU = (totalUsageOfCPU + (Double(threadBasicInfo.cpu_usage) / Double(TH_USAGE_SCALE) * 100.0))
                }
            }
        }

        vm_deallocate(mach_task_self_, vm_address_t(UInt(bitPattern: threadsList)), vm_size_t(Int(threadsCount) * MemoryLayout<thread_t>.stride))
        return totalUsageOfCPU
    }

}
