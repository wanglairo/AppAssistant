//
//  AssistantANRTool.swift
//  AppAssistant
//
//  Created by wangbao on 2020/11/2.
//

import Foundation

class AssistantANRTool: NSObject {

    static func saveANRInfo(info: [String: Any]) {
        guard info.isEmpty == false, let title = info["title"] as? String else {
            return
        }
        let manager = FileManager.default
        let anrDirectoryPath = anrDirectory()
        if anrDirectoryPath.isEmpty == false && manager.fileExists(atPath: anrDirectoryPath) {
            let anrPath = (anrDirectoryPath as NSString).appendingPathComponent("ANR \(title).plist")
            (info as NSDictionary).write(toFile: anrPath, atomically: true)
        }
    }

    static func anrDirectory() -> String {
        guard let cachePath = NSSearchPathForDirectoriesInDomains(.cachesDirectory, .userDomainMask, true).first else {
            return ""
        }
        let directory = (cachePath as NSString).appendingPathComponent("ANR")
        let manager = FileManager.default
        if manager.fileExists(atPath: directory) == false {
            do {
                try manager.createDirectory(atPath: directory, withIntermediateDirectories: true, attributes: nil)
                print("Succes to create folder")
            } catch {
                print("Error to create folder")
            }
        }
        return directory
    }
}
