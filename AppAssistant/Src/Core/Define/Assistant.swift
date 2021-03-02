//
//  Assistant.swift
//  AppAssistant
//
//  Created by zhaochangwu on 2020/10/15.
//

import Foundation

class AssistantKit<T> {

    let base: T

    init(_ base: T) {
        self.base = base
    }
}

protocol AssistantKitWrappable {

    associatedtype WrappableType

    var assk: WrappableType { get }
}

// 协议的扩展
extension AssistantKitWrappable {

    var assk: AssistantKit<Self> {
        return AssistantKit(self)
    }
}
