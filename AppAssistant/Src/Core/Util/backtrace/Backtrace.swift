//
//  Backtrace.swift
//  AppAssistant
//
//  Created by wangbao on 2020/9/30.
//

import Foundation

func backtrace(thread: Thread) -> String {
    let name = "Backtrace of : \(thread.description)\n"
    if Thread.current == thread {
        return name + Thread.callStackSymbols.joined(separator: "\n")
    }
    let mach = machThread(from: thread)
    return name + backtrace(thread: mach)
}

func backtraceMainThread() -> String {
    return backtrace(thread: Thread.main)
}

func backtraceCurrentThread() -> String {
    return backtrace(thread: Thread.current)
}

func backtraceAllThread() -> [String] {
    var count: mach_msg_type_number_t = 0
    // swiftlint:disable implicitly_unwrapped_optional
    var threads: thread_act_array_t!

    guard task_threads(mach_task_self_, &(threads), &count) == KERN_SUCCESS else {
        return [backtrace(thread: mach_thread_self())]
    }
    var symbols = [String]()
    for idx in 0..<count {
        let prefix = "Backtrace of : thread \(idx + 1)\n"
        symbols.append(prefix + backtrace(thread: threads[Int(idx)]))
    }
    return symbols
}

private func backtrace(thread: thread_t) -> String {
    let maxSize: Int32 = 128
    let addrs = UnsafeMutablePointer<UnsafeMutableRawPointer?>.allocate(capacity: Int(maxSize))
    defer { addrs.deallocate() }
    let count = backtrace(thread, stack: addrs, maxSize)
    var symbols: [String] = []
    if let bks = backtrace_symbols(addrs, count) {
        symbols = UnsafeBufferPointer(start: bks, count: Int(count)).map {
            guard let symbol = $0 else {
                return "<null>"
            }
            return String(cString: symbol)
        }
    }
    return symbols.joined(separator: "\n")
}

/// 声明C的符号
@_silgen_name("df_backtrace")
private func backtrace(_ thread: thread_t, stack: UnsafeMutablePointer<UnsafeMutableRawPointer?>!, _ maxSymbols: Int32) -> Int32

@_silgen_name("backtrace_symbols")
private func backtrace_symbols(_ stack: UnsafePointer<UnsafeMutableRawPointer?>!, _ frame: Int32) -> UnsafeMutablePointer<UnsafeMutablePointer<Int8>?>!

/**
    这里主要利用了Thread 和 pThread 共用一个Name的特性，找到对应 thread的内核线程thread_t
    但是主线程不行，主线程设置Name无效.
 */
var mainThreadT: mach_port_t?

private func machThread(from thread: Thread) -> thread_t {

    var count: mach_msg_type_number_t = 0

    var threads: thread_act_array_t!

    guard task_threads(mach_task_self_, &(threads), &count) == KERN_SUCCESS else {
        return mach_thread_self()
    }

    /// 如果当前线程不是主线程，但是需要获取主线程的堆栈
    if !Thread.isMainThread && thread.isMainThread && mainThreadT == nil {
        DispatchQueue.main.sync {
            mainThreadT = mach_thread_self()
        }
        return mainThreadT ?? mach_thread_self()
    }

    let originName = thread.name
    defer {
        thread.name = originName
    }
    let newName = String(Int(Date().timeIntervalSince1970))
    thread.name = newName
    for idx in 0..<count {
        let machThread = threads[Int(idx)]
        if let pthread = pthread_from_mach_thread_np(machThread) {
            var name: [Int8] = [Int8](repeating: 0, count: 128)
            pthread_getname_np(pthread, &name, name.count)
            if thread.name == String(cString: name) {
                return machThread
            }
        }
    }
    return mach_thread_self()
}
