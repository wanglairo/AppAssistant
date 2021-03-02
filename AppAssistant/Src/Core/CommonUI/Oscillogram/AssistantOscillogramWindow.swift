//
//  AssistantOscillogramWindow.swift
//  Alamofire
//
//  Created by wangbao on 2020/10/15.
//

import Foundation
import UIKit

protocol AssistantOscillogramWindowDelegate: NSObjectProtocol {

    func assistantOscillogramWindowClosed()

}

class AssistantOscillogramWindow: UIWindow {

    private static let single = AssistantOscillogramWindow(frame: .zero)

    class var sharedInstance: AssistantOscillogramWindow {
        return single
    }

    var delegates = NSHashTable<AnyObject>.weakObjects()

    var vc = AssistantOscillogramViewController()

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.windowLevel = .init(UIWindow.Level.statusBar.rawValue + 2)
        self.backgroundColor = UIColor.assistant_colorWithHex(0x000000, andAlpha: 0.33)
        self.layer.masksToBounds = true
        if #available(iOS 13.0, *) {
            for windowScene in UIApplication.shared.connectedScenes where windowScene.activationState == .foregroundActive {
                self.windowScene = windowScene as? UIWindowScene
                break
            }
        }
        addRootVC()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func addDelegate(delegate: AssistantOscillogramWindowDelegate) {
        delegates.add(delegate)
    }

    func removeDelegate(delegate: AssistantOscillogramWindowDelegate) {
        delegates.remove(delegate)
    }

    func addRootVC() {

    }

    override func point(inside point: CGPoint, with event: UIEvent?) -> Bool {
        if self.vc.closeBtn.frame.contains(point) {
            return super.point(inside: point, with: event)
        }
        return false
    }

    func show() {
        self.isHidden = false
        vc.startRecord()
        resetLayout()
    }

    func hide() {
        vc.endRecord()
        self.isHidden = true
        resetLayout()

        for item in self.delegates.allObjects {
            let delegate = item as? AssistantOscillogramWindowDelegate
            delegate?.assistantOscillogramWindowClosed()
        }
    }

    func resetLayout() {
        AssistantOscillogramWindowManager.shared.resetLayout()
    }

}
