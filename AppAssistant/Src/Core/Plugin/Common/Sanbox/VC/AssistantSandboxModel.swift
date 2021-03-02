//
//  AssistantSandboxModel.swift
//  AppAssistant
//
//  Created by wangbao on 2020/11/2.
//

import Foundation

enum AssistantSandboxFileType {
    case directory
    case file
    case back
    case root
}

struct AssistantSandboxModel {

    var name: String?

    var path: String?

    var type: AssistantSandboxFileType?

}
