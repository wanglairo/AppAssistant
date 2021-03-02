//
//  Sandbox+Model.swift
//  AppAssistant
//
//  Created by 王来 on 2020/11/17.
//

import Foundation

struct SandboxModel {
    enum `Type` {
        case directory// 目录
        case file // 文件
        case back// 返回
        case root// 根目录
    }

    let name: String
    let url: URL
    let type: Type
}
