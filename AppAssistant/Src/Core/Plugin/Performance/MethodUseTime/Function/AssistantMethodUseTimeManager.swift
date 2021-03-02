//
//  AssistantMethodUseTimeManager.swift
//  AppAssistant
//
//  Created by wangbao on 2020/11/16.
//

class AssistantMethodUseTimeManager: NSObject {

    var switchOn: Bool {
        get {
            AssistantCacheManager.shared.methodUseTimeSwitch()
        }
        set {
            AssistantCacheManager.shared.saveMethodUseTimeSwitch(newValue)
        }
    }

    static let sharedInstance = AssistantMethodUseTimeManager()

    func fixLoadModeArray() -> [Any] {
        let loadMoreArray = dlaLoadModels
        loadMoreArray?.sort(comparator: { (obj1: Any, obj2: Any) -> ComparisonResult in
            let value1 = obj1 as? NSDictionary
            let value2 = obj2 as? NSDictionary
            let objValue1 = value1?["cost"] as? Float ?? 0
            let objValue2 = value2?["cost"] as? Float ?? 0
            if objValue1 < objValue2 {
                return .orderedDescending
            } else {
                return .orderedAscending
            }
        })
        var allCost: Float = 0
        loadMoreArray?.forEach({ (item: Any) in
            let costDict = item as? NSDictionary
            let cost = costDict?["cost"] as? Float ?? 0
            allCost += cost
            let allDict = ["name": localizedString("总共耗时"), "cost": allCost] as [String: Any]
            loadMoreArray?.insert(allDict, at: 0)
        })
        return loadMoreArray as? [Any] ?? [Any]()
    }

    func fixLoadModeArrayForHealth() {

    }

}
