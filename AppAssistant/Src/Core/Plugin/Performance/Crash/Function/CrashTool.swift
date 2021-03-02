//
//  CrashTool.swift
//  AppAssistant
//
//  Created by 王来 on 2020/11/17.
//

import Foundation

extension Crash {

    enum Tool {

        static func save(crash log: String, file name: String) throws {
            guard !log.isEmpty else {
                return
            }
            // 获取当前年月日字符串
            let crashDirectory = try directory()
            // 获取crash保存的路径
            let filePath = crashDirectory.appendingPathComponent(
                "Crash(\(name)) \(AssistantUtil.dateFormatNow()).txt"
            )

            try log.write(to: filePath, atomically: true, encoding: .utf8)
        }

        static func directory() throws -> URL {
            let manager = FileManager.default
            let url = try manager.url(for: .cachesDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
            let path = url.appendingPathComponent("com.assistant.cache.crash")
            if !manager.fileExists(atPath: path.path) {
                try manager.createDirectory(at: path, withIntermediateDirectories: true, attributes: nil)
            }
            return path
        }
    }
}
