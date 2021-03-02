//
//  UIViewController+UIProfile.swift
//  AppAssistant
//
//  Created by 王来 on 2020/11/10.
//

extension UIViewController {

    func profileViewDepth() {
        guard UIProfileManager.shared.isEnable else {
            return
        }
        travelView(view: view, depth: 0)
        showUIProfile()
    }

    func resetProfileData() {
        dokitDepth = 0
        dokitDepthView?.layer.borderWidth = 0
        dokitDepthView?.layer.borderColor = nil
    }

    private func travelView(view: UIView, depth: Int) {
        let newDepth = depth + 1
        if newDepth > self.dokitDepth {
            dokitDepth = newDepth
            dokitDepthView = view
        }
        guard !view.subviews.isEmpty else {
            return
        }
        view.subviews.forEach { subview in
            travelView(view: subview, depth: newDepth)
        }
    }

    private func showUIProfile() {
        guard let view = dokitDepthView else {
            return
        }
        let text = String(format: "[%d][%@]", self.dokitDepth, name(of: view))
        var classNames = [name(of: view)]
        var nextView = view.superview
        while let curView = nextView, curView != self.view {
            classNames.append(name(of: curView))
            nextView = curView.superview
        }
        classNames.append(name(of: self.view))
        let detail = classNames.reversed().reduce("") { $0 + $1 + "\r\n" }
        UIProfileWindow.shared.show(depthText: text, detailInfo: detail)
        view.layer.borderWidth = 1
        view.layer.borderColor = UIColor.red.cgColor
    }

}

// MARK: -
extension UIViewController {

    @objc
    func asskit_viewDidAppear(_ animated: Bool) {
        asskit_viewDidAppear(animated)
        profileViewDepth()
    }

    @objc
    func asskit_viewWillDisappear(_ animated: Bool) {
        asskit_viewWillDisappear(animated)
        resetProfileData()
    }
}

private var dokitDepthKey: Void?
private var dokitDepthViewKey: Void?

extension UIViewController {

    var dokitDepth: Int {
        get { objc_getAssociatedObject(self, &dokitDepthKey) as? Int ?? 0 }
        set { objc_setAssociatedObject(self, &dokitDepthKey, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC) }
    }

    var dokitDepthView: UIView? {
        get { objc_getAssociatedObject(self, &dokitDepthViewKey) as? UIView }
        set { objc_setAssociatedObject(self, &dokitDepthViewKey, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC) }
    }
}

private func name<T>(of cls: T) -> String where T: AnyObject {
    NSStringFromClass(type(of: cls))
}
