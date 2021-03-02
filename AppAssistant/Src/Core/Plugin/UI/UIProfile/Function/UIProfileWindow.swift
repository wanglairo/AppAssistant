//
//  UIProfileWindow.swift
//  AppAssistant
//
//  Created by 王来 on 2020/11/10.
//

private let windowWidth = 220
private let expandHeight = 250
private let textHeight = 30

class UIProfileWindow: UIWindow {

    static let shared = UIProfileWindow(frame: CGRect(x: 10, y: 65, width: windowWidth, height: textHeight))

    var storedFrame = CGRect.zero

    lazy var textLb: UILabel = {
        let tLb = UILabel(frame: CGRect(x: 0, y: 0, width: windowWidth, height: textHeight))
        tLb.backgroundColor = .lightGray
        tLb.textAlignment = .center
        return tLb
    }()

    lazy var textView: UITextView = {
        let tvw = UITextView(frame: CGRect(x: 0, y: textHeight, width: windowWidth, height: expandHeight - textHeight))
        tvw.backgroundColor = .clear
        tvw.textAlignment = .center
        tvw.isEditable = false
        tvw.isUserInteractionEnabled = false
        return tvw
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func show(depthText: String, detailInfo: String) {
        textLb.text = depthText
        textView.text = detailInfo
        addSubview(textLb)
        addSubview(textView)
        isHidden = false
    }

    func hide() {
        textLb.removeFromSuperview()
        textView.removeFromSuperview()
        isHidden = true
    }
}

extension UIProfileWindow {
    private func setupUI() {
        if #available(iOS 13.0, *) {
            for windowScene in UIApplication.shared.connectedScenes {
                guard let windowScene = windowScene as? UIWindowScene else { continue }
                if windowScene.activationState == .foregroundActive { break }
            }
        }
        backgroundColor = .white
        layer.borderWidth = 2
        layer.borderColor = UIColor.lightGray.cgColor
        windowLevel = .statusBar + UIWindow.Level(rawValue: 50).rawValue
        clipsToBounds = true
        let pan = UIPanGestureRecognizer(target: self, action: #selector(onPan(sender:)))
        addGestureRecognizer(pan)
        let tap = UITapGestureRecognizer(target: self, action: #selector(onTap))
        addGestureRecognizer(tap)
    }

    @objc
    func onPan(sender: UIPanGestureRecognizer) {
        let offsetPoint = sender.translation(in: sender.view)
        sender.setTranslation(CGPoint.zero, in: sender.view)
        guard let panView = sender.view else {
            return
        }
        var newX = panView.assk.centerX + offsetPoint.x
        var newY = panView.assk.centerY + offsetPoint.y
        if newX < self.assk.width / 2 {
            newX = self.assk.width / 2
        }

        if newX > screenWidth - self.assk.width / 2 {
            newX = screenWidth - self.assk.width / 2
        }

        if newY < self.assk.height / 2 {
            newY = self.assk.height / 2
        }

        if newY > screenHeight - self.assk.height / 2 {
            newY = screenHeight - self.assk.height / 2
        }

        panView.center = CGPoint(x: newX, y: newY)
    }

    @objc
    func onTap() {
        if storedFrame.isEmpty {
            storedFrame = CGRect(x: assk.x, y: assk.y, width: assk.width, height: 180)
        }
        UIView.animate(withDuration: 0.25) {
            (self.frame, self.storedFrame) = (self.storedFrame, self.frame)
        }
    }
}
