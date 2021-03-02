//
//  VisualInfoWindow.swift
//  AppAssistant
//
//  Created by 王来 on 2020/11/9.
//

import UIKit

enum VisualInfo {

}

class VisualInfoWindow<View: UIView>: UIWindow {

    private(set) var view = View()

    private var closeObserver: NSObjectProtocol?

    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }

    private func setup() {
        if #available(iOS 13, *) {
            if
                let scene = UIApplication.shared.connectedScenes.first(where: { $0.activationState == .foregroundActive }),
                let windowScene = scene as? UIWindowScene {
                self.windowScene = windowScene
            }
        }

        backgroundColor = .clear
        windowLevel = .statusBar + 1.1
        rootViewController = VisualInfoController()
        rootViewController?.view.addSubview(view)

        addGestureRecognizer(UIPanGestureRecognizer(panAction))

        closeObserver = NotificationCenter.default.addObserver(
            forName: .closePlugin,
            object: nil,
            queue: .main
        ) { [weak self] (_) in
            self?.hide()
        }
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        view.frame = bounds
    }

    deinit {
        NotificationCenter.default.removeObserver(closeObserver as Any)
    }
}

// MARK: - Public
extension VisualInfoWindow {

    func show() {
        isHidden = false
    }

    func hide() {
        isHidden = true
    }
}

// MARK: - Actions
extension VisualInfoWindow {

    private func panAction(_ sender: UIPanGestureRecognizer) {
        guard let view = sender.view else {
            return
        }
        // 1、获得拖动位移
        let offsetPoint = sender.translation(in: view)
        // 2、清空拖动位移
        sender.setTranslation(.zero, in: view)
        // 3、重新设置控件位置
        view.center = CGPoint(
            x: view.assk.centerX + offsetPoint.x,
            y: view.assk.centerY + offsetPoint.y
        )
    }
}

class VisualInfoController: UIViewController {

    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        DispatchQueue.main.async {
            let x: CGFloat = 30.fitSizeFrom750Landscape
            self.view.window?.frame = CGRect(
                x: x,
                y: screenHeight - x - min(size.width, size.height),
                width: size.height,
                height: size.width
            )
        }
    }
}

private var UIGestureRecognizerWrapperKey: Void?

private extension UIGestureRecognizer {

    private var wrapper: Any? {
        get { objc_getAssociatedObject(self, &UIGestureRecognizerWrapperKey) }
        set { objc_setAssociatedObject(self, &UIGestureRecognizerWrapperKey, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC) }
    }

    convenience init<T: UIGestureRecognizer>(_ closure: @escaping (T) -> Void) {
        let wrapper = Wrapper(closure)
        self.init(target: wrapper, action: #selector(Wrapper<T>.action))
        self.wrapper = wrapper
    }

    class Wrapper<T>: NSObject {
        let value: ((T) -> Void)?

        init(_ value: @escaping (T) -> Void) {
            self.value = value
        }

        @objc
        func action(_ sender: UIGestureRecognizer) {
            guard let sender = sender as? T else {
                return
            }
            value?(sender)
        }
    }
}
