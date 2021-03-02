//
//  AssistantOscillogramWindowManager.swift
//  AppAssistant
//
//  Created by 王来 on 2020/10/9.
//

import Foundation

class AssistantOscillogramWindowManager: NSObject {

    static let shared = AssistantOscillogramWindowManager()

    var fpsWindow: AssistantFPSOscillogramWindow?

    var cpuWindow: AssistantCPUOscillogramWindow?

    var memoryWindow: AssistantMemoryOscillogramWindow?

    var netFlowWindow: AssistantNetFlowOscillogramWindow?

    override init() {
        super.init()

        fpsWindow = AssistantFPSOscillogramWindow.sharedInstance
        cpuWindow = AssistantCPUOscillogramWindow.sharedInstance
        memoryWindow = AssistantMemoryOscillogramWindow.sharedInstance
        netFlowWindow = AssistantNetFlowOscillogramWindow.shared
    }

    func resetLayout() {
        var offsetY = (isInterfaceOrientationPortrait && isIPhoneXSeries) ? 32 : 0
        let width = isInterfaceOrientationPortrait ? Int(screenWidth) : Int(screenHeight)
        let height = Int(240.fitSizeFrom750Landscape)
        if fpsWindow?.isHidden == false {
            fpsWindow?.frame = CGRect(x: 0, y: Int(offsetY), width: width, height: height)
            offsetY += Int((fpsWindow?.assk.height ?? 0 + 4.fitSizeFrom750Landscape))
        }
        if cpuWindow?.isHidden == false {
            cpuWindow?.frame = CGRect(x: 0, y: Int(offsetY), width: width, height: height)
            offsetY += Int((cpuWindow?.assk.height ?? 0 + 4.fitSizeFrom750Landscape))
        }
        if memoryWindow?.isHidden == false {
            memoryWindow?.frame = CGRect(x: 0, y: Int(offsetY), width: width, height: height)
            offsetY += Int(memoryWindow?.assk.height ?? 0 + 4.fitSizeFrom750Landscape)
        }
        if netFlowWindow?.isHidden == false {
            netFlowWindow?.frame = CGRect(x: 0, y: Int(offsetY), width: width, height: height)
            offsetY += Int(netFlowWindow?.assk.height ?? 0 + 4.fitSizeFrom750Landscape)
        }
    }
}
