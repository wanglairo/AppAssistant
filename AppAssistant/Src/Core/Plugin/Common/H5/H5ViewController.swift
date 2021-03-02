//
//  DoraemonH5SwiftViewController.swift
//  Alamofire
//
//  Created by 王来 on 2020/9/17.
//

import UIKit

 class H5ViewController: UIViewController {

    private lazy var inputTextField: UITextField = {

        let textField = UITextField()
        textField.attributedPlaceholder = NSAttributedString(string: "请输入地址", attributes: [NSAttributedString.Key.foregroundColor: UIColor.assistant_black_3()])
        textField.tintColor = UIColor.assistant_colorWithHexString("#FF8533")
        textField.font = UIFont.regular(16)
        textField.textColor = UIColor.assistant_colorWithHexString("#A5A7AD")
        textField.clearButtonMode = .whileEditing
        textField.layer.cornerRadius = 12
        textField.backgroundColor = UIColor.assistant_colorWithHexString("CCF7F8FA")
        return textField
    }()

    private lazy var textLabel: UILabel = {

        let label = UILabel()
        label.font = UIFont.regular(14)
        label.textColor = UIColor.assistant_colorWithHexString("#A5A7AD")
        label.numberOfLines = 0
        label.text = "手动输入或通过扫码获取地址。然后点击打开，即可查看H5。"
        return label
    }()

    private lazy var bottomBtn: UIButton = {

        let btn = UIButton(type: .custom)
        btn.setTitle("打开H5", for: .normal)
        btn.setTitleColor(UIColor.white, for: .normal)
        btn.titleLabel?.font = UIFont.medium(16)
        btn.backgroundColor = UIColor.assistant_colorWithHexString("2979E1")
        btn.layer.cornerRadius = 8
        btn.addTarget(self, action: #selector(bottomBtnClick), for: .touchUpInside)
        return btn
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        setUpUI()
    }

    func setUpUI() {

        self.view.backgroundColor = .white

        assistant_setNavTitle(localizedString("H5任意门"))
        assistant_setNavRight(imageText: "icon_saoma")

        let inputTextFieldH = 60.fitSizeFrom750

        view.addSubview(inputTextField)
        inputTextField.snp.makeConstraints {
            $0.top.equalToSuperview().offset(12.fitSizeFrom750)
            $0.left.equalToSuperview().offset(16.fitSizeFrom750)
            $0.right.equalToSuperview().offset(-16.fitSizeFrom750)
            $0.height.equalTo(inputTextFieldH)
        }

        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: inputTextFieldH))
        inputTextField.leftView = paddingView
        inputTextField.leftViewMode = .always

        view.addSubview(textLabel)
        textLabel.snp.makeConstraints {
            $0.top.equalTo(inputTextField.snp.bottom).offset(12.fitSizeFrom750)
            $0.left.equalToSuperview().offset(16.fitSizeFrom750)
            $0.right.equalToSuperview().offset(-16.fitSizeFrom750)
        }

        view.addSubview(bottomBtn)
        bottomBtn.snp.makeConstraints {
            $0.bottom.equalToSuperview().offset(-(isIPhoneXSeries ? 60.fitSizeFrom750 : 16.fitSizeFrom750 ))
            $0.left.equalToSuperview().offset(18.fitSizeFrom750)
            $0.right.equalToSuperview().offset(-18.fitSizeFrom750)
            $0.height.equalTo(48)
        }
    }

    override func assistant_rightBtnClick(sender: UIButton) {
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)

        inputTextField.resignFirstResponder()
    }

    @objc
    func bottomBtnClick() {

        guard let text = inputTextField.text, !text.isEmpty else {
            ToastUtil.showToast(localizedString("链接不能为空"), superView: view)
            return
        }

        openWebView(urlStr: text)
    }

    func openWebView(urlStr: String) {

        AssistantManager.shared.openWebViewBlock?(urlStr, self.navigationController)
    }

}
