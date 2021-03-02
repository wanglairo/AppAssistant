//
//  Crash.swift
//  AppAssistant
//
//  Created by 王来 on 2020/11/17.
//

import Foundation

enum Crash {
    struct Model {

        // swiftlint:disable nesting
        enum `Type`: String {
            case signal = "Signal"
            case exception = "Exception"
        }
        // swiftlint:enable nesting

        let type: Type
        let name: String
        let reason: String?
        let symbols: [String]
    }

    // crash信息可以抛给外界自定义处理
    static var handler: ((Model) -> Void)? = {
        let info = """
        ======================== \($0.type.rawValue)异常错误报告 ========================
        name: \($0.name)
        reason: \($0.reason ?? "unknown")

        Call Stack:
        \($0.symbols.joined(separator: "\r"))

        ThreadInfo:
        \(Thread.current.description)

        AppInfo:
        \(appInfo)
        """
        // 存沙盒或者发邮件
        try? Crash.Tool.save(crash: info, file: "\($0.type.rawValue)")
    }

    // swiftlint:disable redundant_optional_initialization
    private static var appOldExceptionHandler:(@convention(c) (NSException) -> Swift.Void)? = nil
    // swiftlint:enable redundant_optional_initialization

    static func register() {
        setupSignalHandler()
        setupExceptionHandler()
    }

    private static func setupExceptionHandler() {
        appOldExceptionHandler = NSGetUncaughtExceptionHandler()
        NSSetUncaughtExceptionHandler(Crash.recieveException)
    }

    private static func setupSignalHandler() {
        //http://stackoverflow.com/questions/36325140/how-to-catch-a-swift-crash-and-do-some-logging
        signal(SIGABRT, Crash.recieveSignal)
        signal(SIGBUS, Crash.recieveSignal)
        signal(SIGFPE, Crash.recieveSignal)
        signal(SIGILL, Crash.recieveSignal)
        signal(SIGPIPE, Crash.recieveSignal)
        signal(SIGSEGV, Crash.recieveSignal)
        signal(SIGSYS, Crash.recieveSignal)
        signal(SIGTRAP, Crash.recieveSignal)
    }
}

extension Crash {

    private static let recieveException: @convention(c) (NSException) -> Void = { (exteption) -> Void in
        appOldExceptionHandler?(exteption)
        let model = Model(type: .exception,
                          name: "\(exteption.name)",
                          reason: exteption.reason,
                          symbols: exteption.callStackSymbols)
        handler?(model)
        killApp()
    }

    private static let recieveSignal : @convention(c) (Int32) -> Void = { (signal) -> Void in
        var stack = Thread.callStackSymbols
        stack.removeFirst()
        let model = Model(type: .signal,
                          name: signal.signalName,
                          reason: "Signal \(signal.signalName)(\(signal)) was raised.",
                          symbols: stack)

        handler?(model)
        killApp()
    }

    private static func killApp() {
        NSSetUncaughtExceptionHandler(nil)

        signal(SIGABRT, SIG_DFL)
        signal(SIGBUS, SIG_DFL)
        signal(SIGFPE, SIG_DFL)
        signal(SIGILL, SIG_DFL)
        signal(SIGPIPE, SIG_DFL)
        signal(SIGSEGV, SIG_DFL)
        signal(SIGSYS, SIG_DFL)
        signal(SIGTRAP, SIG_DFL)

        kill(getpid(), SIGKILL)
    }
}

fileprivate extension Int32 {

    var signalName: String {
        switch self {
        case SIGABRT:   return "SIGABRT"
        case SIGBUS:    return "SIGBUS"
        case SIGFPE:    return "SIGFPE"
        case SIGILL:    return "SIGILL"
        case SIGPIPE:   return "SIGPIPE"
        case SIGSEGV:   return "SIGSEGV"
        case SIGSYS:    return "SIGSYS"
        case SIGTRAP:   return "SIGTRAP"
        default:        return "UNKNOWN"
        }
    }
}

extension Crash {

    private static var appInfo: String {
        let displayName = Bundle.main.object(forInfoDictionaryKey: "CFBundleName") ?? ""
        let shortVersion = Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") ?? ""
        let version = Bundle.main.object(forInfoDictionaryKey: "CFBundleVersion") ?? ""
        let deviceModel = UIDevice.current.model
        let systemName = UIDevice.current.systemName
        let systemVersion = UIDevice.current.systemVersion
        return """
        App: \(displayName) \(shortVersion)(\(version))
        Device:\(deviceModel)
        OS Version:\(systemName) \(systemVersion)
        """
    }
}
