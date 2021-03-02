//
//  AssistantMockGPSInputView.swift
//  AppAssistant
//
//  Created by wangbao on 2020/10/12.
//

import Foundation

protocol AssistantMockGPSInputViewDelegate: NSObjectProtocol {
    func inputViewOkClick(gps: String)
}

extension AssistantMockGPSInputViewDelegate {
    func inputViewOkClick(gps: String) {

    }
}

class AssistantMockGPSInputView: UIView {

    weak var delegate: AssistantMockGPSInputViewDelegate?

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.layer.cornerRadius = 8.fitSizeFrom750Landscape
        if #available(iOS 13.0, *) {
            self.backgroundColor = UIColor.systemBackground
        } else {
            self.backgroundColor = UIColor.clear
        }
        addSubview(textField)
        addSubview(searchBtn)
        addSubview(lineView)
        addSubview(exampleLabel)

        textField.snp.makeConstraints { (maker) in
            maker.left.equalTo(32.fitSizeFrom750Landscape)
            maker.top.equalTo(40.fitSizeFrom750Landscape)
            maker.right.equalTo(-32.fitSizeFrom750Landscape)
            maker.height.equalTo(45.fitSizeFrom750Landscape)
        }
        searchBtn.snp.makeConstraints { (maker) in
            maker.right.equalTo(0)
            maker.width.equalTo(120.fitSizeFrom750Landscape)
            maker.height.equalTo(120.fitSizeFrom750Landscape)
            maker.top.equalTo(0)
        }
        lineView.snp.makeConstraints { (maker) in
            maker.left.equalTo(32.fitSizeFrom750Landscape)
            maker.top.equalTo(textField.snp.bottom).offset(19.fitSizeFrom750Landscape)
            maker.right.equalTo(-32.fitSizeFrom750Landscape)
            maker.height.equalTo(1.fitSizeFrom750Landscape)
        }
        exampleLabel.snp.makeConstraints { (maker) in
            maker.left.equalTo(32.fitSizeFrom750Landscape)
            maker.top.equalTo(lineView.snp.bottom).offset(15.fitSizeFrom750Landscape)
            maker.right.equalTo(0)
            maker.height.equalTo(33.fitSizeFrom750Landscape)
        }
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    lazy var textField: UITextField = {
        let txtField = UITextField()
        txtField.placeholder = localizedString("请输入经纬度")
        txtField.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
        return txtField
    }()

    lazy var searchBtn: UIButton = {
        let searchBtn = UIButton()
        searchBtn.imageView?.contentMode = .center
        searchBtn.setImage(UIImage.assistant_xcassetImageNamed(name: "doraemon_search"), for: .normal)
        searchBtn.addTarget(self, action: #selector(searchBtnClick), for: .touchUpInside)
        return searchBtn
    }()

    lazy var lineView: UIView = {
        let line = UIView()
        line.backgroundColor = UIColor.assistant_colorWithHexString("#EEEEEE")
        return line
    }()

    lazy var exampleLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor.assistant_black_3()
        label.font = UIFont.systemFont(ofSize: 24.fitSizeFrom750Landscape)
        label.text = localizedString("(示例: 120.15 30.28)")
        return label
    }()

    @objc
    func textFieldDidChange(sender: UITextField) {
        // 去除首尾空格
        let textSearchStr = sender.text?.trimmingCharacters(in: NSCharacterSet.whitespaces)
        if textSearchStr?.isEmpty == false {
            searchBtn.setImage(UIImage.assistant_xcassetImageNamed(name: "doraemon_search_highlight"), for: .normal)
        } else {
            searchBtn.setImage(UIImage.assistant_xcassetImageNamed(name: "doraemon_search"), for: .normal)
        }
    }

    @objc
    func searchBtnClick(sender: UIButton) {
        let textSearchStr = textField.text?.trimmingCharacters(in: NSCharacterSet.whitespaces)
        if textSearchStr?.isEmpty == false {
            delegate?.inputViewOkClick(gps: textSearchStr ?? "")
        }
    }
}
