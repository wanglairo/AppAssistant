//
//  AssistantManager.swift
//  AppAssistant
//
//  Created by 王来 on 2020/9/29.
//

import CoreLocation

typealias AssistantANRBlock = ([String: Any]) -> Void
typealias AssistantOpenWebBlock = (String, UINavigationController?) -> Void
typealias AssistantSwitchEnvBlock = (String) -> Void

class AssistantManager: NSObject {

    static let shared = AssistantManager()

    var pluginMap = [PluginModule: [PluginProtocol]]()
    var modules = [PluginModule]()

    var anrBlock: AssistantANRBlock?

    var openWebViewBlock: AssistantOpenWebBlock?

    var switchEnvBlock: AssistantSwitchEnvBlock?

    var env: [String] = []

    private var hasInstall = false

    override private init() {
        super.init()

        self.install()
    }

    func install() {

        installWithCustomBlock()
    }

    func showAssistant() {
        AssistantMenu.core.showAssistant()
    }

    func hiddenAssistant() {
        AssistantMenu.core.hiddenAssistant()
    }

    func addANRBlock(block: @escaping ([String: Any]) -> Void) {
        self.anrBlock = block
    }

    func isShowAssistant() {
        return AssistantMenu.core.isShowAssistant()
    }

    /// 注册环境
    func registerEnv(_ env: [String], switchAction: @escaping (String) -> Void) {
        self.switchEnvBlock = switchAction
        self.env = env
    }

    /// 注册环境切换控制器
    func registerOpenWebView(block: @escaping (String, UINavigationController?) -> Void) {
        self.openWebViewBlock = block
    }
}

extension AssistantManager {

    func installWithCustomBlock() {

        if hasInstall {
            return
        }

        hasInstall = true
        initPluginData()
        setup()
        initMenu()
    }

    func initPluginData() {

        /** Common */
        addPlugin(plugin: SwitchEnvPlugin())
        addPlugin(plugin: AppInfoPlugin())
        addPlugin(plugin: GPSPlugin())
        addPlugin(plugin: H5Plugin())

        /** Performance */
        addPlugin(plugin: FPSPlugin())
        addPlugin(plugin: CPUPlugin())
        addPlugin(plugin: MemoryPlugin())
        addPlugin(plugin: NetFlowPlugin())
        addPlugin(plugin: ANRPlugin())
        addPlugin(plugin: MethodUseTimePlugin())
        addPlugin(plugin: LaunchTimePlugin())
        addPlugin(plugin: CrashPlugin())
        addPlugin(plugin: MemoryLeakPlugin())

        /** UI */
        addPlugin(plugin: ViewAlignPlugin())
        addPlugin(plugin: ViewCheckPlugin())
        addPlugin(plugin: ViewMetricsPlugin())
        addPlugin(plugin: ColorPickPlugin())
        addPlugin(plugin: UIProfilePlugin())

        /* 关闭*/
        addPlugin(plugin: AssistantClosedPlugin())
    }

    func addPlugin(plugin: PluginProtocol) {
        plugin.onInstall()
        if pluginMap[plugin.module] != nil {
            pluginMap[plugin.module]?.append(plugin)
        } else {
            modules.append(plugin.module)
            pluginMap[plugin.module] = [plugin]
        }
    }

    func addPlugin(module: PluginModule,
                   title: String,
                   icon: String?,
                   onInstall: (() -> Void)?,
                   onSelected: (() -> Void)?) {

        let plugin = DefaultPlugin(module: module, title: title, icon: icon, onInstallClosure: onInstall, onSelectedClosure: onSelected)
        addPlugin(plugin: plugin)
    }

    func setup() {

        if AssistantCacheManager.shared.crashSwitch() {
            Crash.register()
        }

        /// 流量监控
        if AssistantCacheManager.shared.netFlowSwitch() {
            NetFlowManager.shared.canInterceptNetFlow(true)
            AssistantNetFlowOscillogramWindow.shared.show()
        } else {
            NetFlowManager.shared.canInterceptNetFlow(false)
            AssistantNetFlowOscillogramWindow.shared.hide()
        }

        AssistantCacheManager.shared.saveFpsSwitch(false)
        AssistantCacheManager.shared.saveMemorySwitch(false)
        AssistantCacheManager.shared.saveCpuSwitch(false)

        if AssistantCacheManager.shared.mockGPSSwitch() {
            AssistantGPSMocker.shareInstance.startHookDelegate()
            let coordinate = AssistantCacheManager.shared.mockCoordinate()
            let loc = CLLocation(latitude: coordinate.latitude, longitude: coordinate.longitude)
            AssistantGPSMocker.shareInstance.mockPoint(location: loc)
        }

        AssistantANRManager.sharedInstance.addANRBlock { (anrInfo) in
            self.anrBlock?(anrInfo)
        }

        if AssistantCacheManager.shared.memoryLeak() {
            UIApplication.onceApplicationSwizzle()
            UINavigationController.navigationSwizzleMethod()
            UIViewController.onceSwizzleMethod()
        }
    }

    func initMenu() {

        AssistantMenu.core.config.debuging = false
        var opts: [AssistantMenu.Config.Option] = []
        for item in modules {
            let opt = AssistantMenu.Config.Option()
            opt.title = item.name
            opt.skin = item.icon
            if let array = pluginMap[item] {
                for element in array {
                    let optttt = AssistantMenu.Config.Option()
                    optttt.title = element.title
                    optttt.skin = element.icon
                    optttt.action = { /// item 点击
                        element.onSelected()
                        AssistantMenu.core.closeMunuEvent()
                    }
                    opt.subOption.append(optttt)
                }
            }
            opts.append(opt)
        }

        AssistantMenu.core.config.options = opts
        AssistantMenu.core.start()
    }

}

extension AssistantManager {

    func closeSwitchs() {

        AssistantCacheManager.shared.saveLoggerSwitch(false)
        AssistantCacheManager.shared.saveMockGPSSwitch(false)
        AssistantCacheManager.shared.saveNetFlowSwitch(false)
        /// 流量监控
        if !AssistantCacheManager.shared.netFlowSwitch() {
            NetFlowManager.shared.canInterceptNetFlow(false)
            AssistantNetFlowOscillogramWindow.shared.hide()
        }
        AssistantCacheManager.shared.saveAllTestSwitch(false)
        AssistantCacheManager.shared.saveLargeImageDetectionSwitch(false)
        AssistantCacheManager.shared.saveSubThreadUICheckSwitch(false)
        AssistantCacheManager.shared.saveCrashSwitch(false)
        AssistantCacheManager.shared.saveMethodUseTimeSwitch(false)
        AssistantCacheManager.shared.saveStartTimeSwitch(false)
        AssistantCacheManager.shared.saveANRTrackSwitch(false)
        AssistantCacheManager.shared.saveMemoryLeak(false)
        AssistantCacheManager.shared.saveMemoryLeakAlert(false)
    }

}
