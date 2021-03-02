//
//  MemoryLeakData.swift
//  AppAssistant
//
//  Created by 王来 on 2020/11/23.
//

import FBRetainCycleDetector

class MemoryLeakData: NSObject {

    static let shared = MemoryLeakData()

    private var dataArray = [Any]()

    func addObject(object: AnyObject) {

        let className = NSStringFromClass(type(of: object))
        let classPtr = getUnsafeBytes(sampleStruct: object)
        let viewStack = (object as? NSObject ?? NSObject()).viewStack()
        let retainCycle = getRetainCycleByObject(object: object)
        let info = ["className": className,
                    "classPtr": classPtr,
                    "viewStack": viewStack,
                    "retainCycle": retainCycle] as [String: Any]
        dataArray.append(info)
    }

    func removeObjectPtr(objectPtr: NSNumber) {
        for (index, item) in dataArray.enumerated().reversed() {
            let dataDict = item as? NSDictionary
            if dataDict?.object(forKey: "classPtr") as? NSNumber == objectPtr {
                dataArray.remove(at: index)
            }
        }
    }

    func getResult() -> [Any] {
        return dataArray
    }

    func clearResult() {
        dataArray.removeAll()
    }

    func getRetainCycleByObject(object: AnyObject) -> String {
        var result = ""
        let detector = FBRetainCycleDetector()
        detector.addCandidate(object)
        let retainCycles = detector.findRetainCycles(withMaxCycleLength: 20)
        var hasFound = false
        for retainCycle in retainCycles {
            var index = 0
            guard let cycleList = retainCycle as? [AnyObject] else {
                return result
            }
            for element in cycleList {
                if let elementValue = element as? FBObjectiveCGraphElement {
                    if (elementValue.object?.isEqual(object)) != nil {
                        let shiftedRetainCycle = shiftArray(array: cycleList, toIndex: index)
                        result = String(format: "%@", shiftedRetainCycle)
                        hasFound = true
                        break
                    }
                }
                index += 1
            }
            if hasFound == true {
                break
            }
        }
        if hasFound == false {
            result = "Fail to find a retain cycle"
        }
        return result
    }

    func shiftArray(array: [AnyObject], toIndex index: Int) -> [Any] {
        if index == 0 {
            return array
        }
        let resultTail = array[index...(array.count - index)]
        let resultHeader = array[0...index]
        let result = Array(resultHeader + resultTail)
        return result
    }

}
