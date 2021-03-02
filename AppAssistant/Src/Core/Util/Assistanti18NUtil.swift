//
//  Assistanti18NUtil.swift
//  AppAssistant
//
//  Created by zhaochangwu on 2020/10/19.
//

import Foundation

func localizedString(_ key: String) -> String {
    return Assistanti18NUtil.localizedString(key)
}

class Assistanti18NUtil: NSObject {

    static func localizedString(_ key: String) -> String {
        guard let language = Locale.preferredLanguages.first,
              language.isEmpty == false else {
            return key
        }

        var fileNamePrefix = "zh-Hans"
        if language.hasPrefix("en") {
            fileNamePrefix = "en"
        }
        guard let cls = NSClassFromString("AppAssistant.AssistantManager"),
              let url = Bundle(for: cls).url(forResource: "AppAssistant", withExtension: "bundle"),
              let tmpBundle = Bundle(url: url),
              let path = tmpBundle.path(forResource: fileNamePrefix, ofType: "lproj"),
              let localizedString = Bundle(path: path)?.localizedString(forKey: key, value: nil, table: "AppAssistant") else {
            return key
        }
        return localizedString
    }
}
