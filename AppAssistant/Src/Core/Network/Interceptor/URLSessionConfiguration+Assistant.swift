//
//  URLSessionConfiguration+Assistant.swift
//  AppAssistant
//
//  Created by 王来 on 2020/10/21.
//

extension URLSessionConfiguration {

    static func runtimeReplaceProtocolClasses() {

        DispatchQueue.once(token: "assistantProtocol") {

            let originalSelector = #selector(getter: protocolClasses)
            let swizzledSelector = #selector(assistantProtocolClasses)
            assistant_swizzleInstanceMethodWithOriginSel(oriSel: originalSelector, swiSel: swizzledSelector)
        }
    }

    @objc
    func assistantProtocolClasses() -> [AnyClass] {

        return [AssistantURLProtocol.self]
    }

}
