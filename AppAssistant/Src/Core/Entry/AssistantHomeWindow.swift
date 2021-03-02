//
//  AssistantHomeWindow.swift
//  Alamofire
//
//  Created by 王来 on 2020/10/14.
//

class AssistantHomeWindow: UIWindow {

    static let shared = AssistantHomeWindow(frame: CGRect(x: 0, y: 0, width: screenWidth, height: screenHeight))

    private var nav: AssistantNavigationController?

    override init(frame: CGRect) {
        super.init(frame: frame)

        self.windowLevel = .normal
        self.backgroundColor = .clear
        if #available(iOS 13.0, *) {
            self.overrideUserInterfaceStyle = .light
        }

    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func openPlugin(_ vc: UIViewController) {
        setRootVc(rootVc: vc)
        self.isHidden = false
    }

    private func setRootVc(rootVc: UIViewController) {
        rootVc.assistant_setNavBack()
        nav = AssistantNavigationController(rootViewController: rootVc)
        nav?.delegate = self
        nav?.interactivePopGestureRecognizer?.delegate = self
        nav?.navigationBar.titleTextAttributes = [
            .foregroundColor: UIColor.white,
            .font: UIFont.medium(18) as Any
        ]
        self.rootViewController = nav
    }

    static func openPlugin(_ vc: UIViewController) {
        self.shared.openPlugin(vc)
    }

}

extension AssistantHomeWindow: UINavigationControllerDelegate, UIGestureRecognizerDelegate {

    func navigationController(_ navigationController: UINavigationController, didShow viewController: UIViewController, animated: Bool) {
        if navigationController.responds(to: #selector(getter: UINavigationController.interactivePopGestureRecognizer)) {
            if navigationController.viewControllers.count > 1 {
                // swiftlint:disable line_length
                navigationController.interactivePopGestureRecognizer?.isEnabled = (viewController.disablePopGestureRecognizer == nil) ? true : !(viewController.disablePopGestureRecognizer ?? false)
            } else {
                navigationController.interactivePopGestureRecognizer?.isEnabled = false
            }
        }
    }

    func navigationController(_ navigationController: UINavigationController, willShow viewController: UIViewController, animated: Bool) {
        if viewController.needBigTitleView ?? false {
            navigationController.setNavigationBarHidden(true, animated: true)
        } else {
            navigationController.setNavigationBarHidden(false, animated: true)
        }
    }

}
