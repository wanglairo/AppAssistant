//
//  UIViewController+Nav.swift
//  AppAssistant
//
//  Created by 王来 on 2020/10/14.
//

extension UIViewController {

    struct DisablePopGestureRecognizerKey {
        static var disablePop = "UIViewController.disablePop"
    }

    struct NeedBigTitleViewKey {
        static var needBig = "UIViewController.needBigTitle"
    }

    var disablePopGestureRecognizer: Bool? {
        get {
            return objc_getAssociatedObject(self, &DisablePopGestureRecognizerKey.disablePop) as? Bool
        }
        set(newValue) {
            objc_setAssociatedObject(self, &DisablePopGestureRecognizerKey.disablePop, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }

    var needBigTitleView: Bool? {
        get {
            return objc_getAssociatedObject(self, &NeedBigTitleViewKey.needBig) as? Bool
        }
        set(newValue) {
            objc_setAssociatedObject(self, &NeedBigTitleViewKey.needBig, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }

    static let bigTitleViewH = 100.fitSizeFrom750 + CGFloat(iPhoneTopSensorHeight)

    func assistant_setNavTitle(_ titleText: String?, textColor: UIColor = UIColor.black) {

        guard let titleText = titleText, !titleText.isEmpty else {
            return
        }

        if let needBigTitleView = needBigTitleView, needBigTitleView {

            navigationController?.setNavigationBarHidden(true, animated: true)

            let bigTitleView = BigTitleView()
            bigTitleView.textLabel.text = titleText
            bigTitleView.closeBtn.addTarget(self, action: #selector(assistant_backBtnClick(sender:)), for: .touchUpInside)

            view.addSubview(bigTitleView)
            bigTitleView.snp.makeConstraints {
                $0.top.left.right.equalToSuperview().offset(0)
                $0.height.equalTo(UIViewController.bigTitleViewH)
            }
        } else {

            navigationController?.setNavigationBarHidden(false, animated: true)

            let titleLabel = UILabel()
            titleLabel.text = titleText
            titleLabel.textAlignment = NSTextAlignment.center
            titleLabel.textColor = textColor
            titleLabel.font = UIFont.medium(18)
            titleLabel.sizeToFit()

            let titleLabelSize = titleLabel.sizeThatFits(CGSize.zero)
            titleLabel.frame = CGRect(x: 0, y: 7, width: titleLabelSize.width, height: titleLabelSize.height)

            self.navigationItem.titleView = titleLabel
        }
    }

    func assistant_setNavBack() {

        let backBtn = UIButton(type: .custom)
        let backBtnImage = UIImage.assistant_xcassetImageNamed(name: "icon_back")
        backBtn.setImage(backBtnImage, for: UIControl.State.normal)
        backBtn.contentHorizontalAlignment = .left
        backBtn.frame = CGRect(x: 0, y: 0, width: 30.fitSizeFrom750, height: 44)
        backBtn.addTarget(self, action: #selector(assistant_backBtnClick(sender:)), for: UIControl.Event.touchUpInside)
        let leftBarButtonItem = UIBarButtonItem(customView: backBtn)

        self.navigationItem.leftBarButtonItem = leftBarButtonItem
    }

    func assistant_setNavLeft(titleText: String = "", imageText: String, titleColor: UIColor = UIColor.white) {

        let leftBtn = UIButton(type: .custom)
        let leftBtnImage = UIImage.assistant_xcassetImageNamed(name: imageText)
        leftBtn.setImage(leftBtnImage, for: .normal)
        leftBtn.titleLabel?.font = UIFont.systemFont(ofSize: 15)
        leftBtn.setTitle(titleText, for: UIControl.State.normal)
        leftBtn.setTitleColor(titleColor, for: .normal)
        if !imageText.isEmpty {
            leftBtn.frame = CGRect(x: 0, y: 0, width: leftBtnImage?.size.width ?? 50.fitSizeFrom750, height: 44)
        }
        if !titleText.isEmpty {
            let titleLabelSize = leftBtn.titleLabel?.sizeThatFits(CGSize.zero)
            leftBtn.frame = CGRect(x: 0, y: 0, width: titleLabelSize?.width ?? 50.fitSizeFrom750, height: 44)
        }
        leftBtn.addTarget(self, action: #selector(assistant_leftBtnClick(sender:)), for: UIControl.Event.touchUpInside)
        let leftBarButtonItem = UIBarButtonItem(customView: leftBtn)

        self.navigationItem.leftBarButtonItem = leftBarButtonItem
    }

    @objc
    func assistant_leftBtnClick(sender: UIButton) {

    }

    @objc
    func assistant_backBtnClick(sender: UIButton) {

        guard let nav = self.navigationController, nav.viewControllers.count > 1 else {

            self.view.window?.isHidden = true
            return
        }

        guard self.navigationController?.popViewController(animated: true) != nil else {

            self.navigationController?.dismiss(animated: true, completion: nil)
            return
        }
    }

    func assistant_setNavRight(titleText: String = "", imageText: String = "", titleColor: UIColor = UIColor.white) {

        let rightBtn = UIButton(type: .custom)
        let rightBtnImage = UIImage.assistant_xcassetImageNamed(name: imageText)
        rightBtn.setImage(rightBtnImage, for: .normal)
        rightBtn.titleLabel?.font = UIFont.systemFont(ofSize: 15)
        rightBtn.titleLabel?.textAlignment = .right
        rightBtn.setTitle(titleText, for: UIControl.State.normal)
        rightBtn.setTitleColor(titleColor, for: .normal)
        if !imageText.isEmpty {
            rightBtn.frame = CGRect(x: 0, y: 0, width: rightBtnImage?.size.width ?? 50.fitSizeFrom750, height: 44)
        }
        if !titleText.isEmpty {
            let titleLabelSize = rightBtn.titleLabel?.sizeThatFits(CGSize.zero)
            rightBtn.frame = CGRect(x: 0, y: 0, width: titleLabelSize?.width ?? 50.fitSizeFrom750, height: 44)
        }
        rightBtn.addTarget(self, action: #selector(assistant_rightBtnClick(sender:)), for: UIControl.Event.touchUpInside)

        let rightBarButtonItem = UIBarButtonItem(customView: rightBtn)

        self.navigationItem.rightBarButtonItem = rightBarButtonItem
    }

    func assistant_setNavEmptyRight() {
        self.navigationItem.rightBarButtonItem = nil
    }

    func assistant_setNavEmptyLeft() {
        self.navigationItem.leftBarButtonItem = nil
    }

    @objc
    func assistant_rightBtnClick(sender: UIButton) {
    }

}

extension UIViewController {

    class BigTitleView: UIView {

        lazy var textLabel: UILabel = {

            let label = UILabel()
            label.font = UIFont.medium(24)
            label.textColor = UIColor.assistant_black_4()
            label.numberOfLines = 0
            label.text = ""
            return label
        }()

        lazy var closeBtn: UIButton = {

            let btn = UIButton(type: .custom)
            btn.setTitle("", for: .normal)
            btn.setImage(UIImage.assistant_xcassetImageNamed(name: "doraemon_close"), for: .normal)
            return btn
        }()

        override init(frame: CGRect) {
            super.init(frame: frame)
            setUpUI()
        }

        required init?(coder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }

        func setUpUI() {

            backgroundColor = .white

            addSubview(textLabel)
            textLabel.snp.makeConstraints {
                $0.left.equalToSuperview().offset(15.fitSizeFrom750)
                $0.centerY.equalToSuperview().offset(iPhoneTopSensorHeight / 2)
            }

            addSubview(closeBtn)
            closeBtn.snp.makeConstraints {
                $0.right.equalToSuperview().offset(-15.fitSizeFrom750)
                $0.centerY.equalToSuperview().offset(iPhoneTopSensorHeight / 2)
            }
        }
    }
}
