//
//  AssistantAlertUtil.swift
//  AppAssistant
//
//  Created by 王来 on 2020/10/9.
//

import Foundation

typealias AssistantAlertOKActionBlock = () -> Void

typealias AssistantAlertCancelActionBlock = () -> Void

class AssistantAlertUtil: NSObject {

    static func handleAlertActionWithVC(vc: UIViewController,
                                        okBlock:@escaping AssistantAlertOKActionBlock,
                                        cancelBlock:@escaping AssistantAlertCancelActionBlock) {
        self.handleAlertActionWithVC(vc: vc, text: localizedString("该功能需要重启App才能生效"), okBlock: okBlock, cancelBlock: cancelBlock)
    }

    static func handleAlertActionWithVC(vc: UIViewController,
                                        title: String = localizedString("提示"),
                                        text: String,
                                        cancelTitle: String = localizedString("取消"),
                                        okTitle: String = localizedString("确定"),
                                        okBlock:@escaping AssistantAlertOKActionBlock,
                                        cancelBlock: @escaping AssistantAlertCancelActionBlock) {
        let alertController = UIAlertController(title: title, message: text, preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: cancelTitle, style: .default) { (_) in
            cancelBlock()
        }
        let okAction = UIAlertAction(title: okTitle, style: .default) { (_) in
            okBlock()
        }
        alertController.addAction(okAction)
        alertController.addAction(cancelAction)
        vc.present(alertController, animated: true, completion: nil)
    }
}
