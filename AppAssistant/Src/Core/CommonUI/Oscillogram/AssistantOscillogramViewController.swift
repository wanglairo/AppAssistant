//
//  AssistantOscillogramViewController.swift
//  Alamofire
//
//  Created by wangbao on 2020/10/15.
//

import Foundation

class AssistantOscillogramViewController: UIViewController {

    var secondTimer: Timer?

    var closeBtn = UIButton(type: .custom)

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = UIColor.clear

        let titleLabel = UILabel()
        titleLabel.backgroundColor = .clear
        titleLabel.text = self.title()
        titleLabel.font = UIFont.systemFont(ofSize: 20.fitSizeFrom750Landscape)
        titleLabel.textColor = .white
        titleLabel.sizeToFit()
        self.view.addSubview(titleLabel)

        closeBtn.setImage(UIImage.assistant_xcassetImageNamed(name: "doraemon_close_white"), for: .normal)
        closeBtn.addTarget(self, action: #selector(closeBtnClick), for: .touchUpInside)
        self.view.addSubview(closeBtn)
        self.view.addSubview(oscillogramView)

        titleLabel.snp.makeConstraints { (maker) in
            maker.left.equalTo(20.fitSizeFrom750Landscape)
            maker.top.equalTo(10.fitSizeFrom750Landscape)
        }
        closeBtn.snp.makeConstraints { (maker) in
            maker.right.equalTo(-40)
            maker.top.equalTo(0)
            maker.size.equalTo(CGSize(width: 80.fitSizeFrom750Landscape, height: 80.fitSizeFrom750Landscape))
        }
        oscillogramView.snp.makeConstraints { (maker) in
            maker.left.equalTo(0)
            maker.top.equalTo(titleLabel.snp.bottom).offset(12.fitSizeFrom750Landscape)
            maker.right.equalTo(0)
            maker.height.equalTo(184.fitSizeFrom750Landscape)
        }
    }

    lazy var oscillogramView: AssistantOscillogramView = {
        let oscillogramView = AssistantOscillogramView(frame: CGRect(x: 0, y: 0, width: 0, height: 184.fitSizeFrom750Landscape))
        oscillogramView.backgroundColor = .clear
        oscillogramView.setLowValue(self.lowValue())
        oscillogramView.setHightValue(self.highValue())
        return oscillogramView
    }()

    @objc
    func closeBtnClick() {

    }

    func startRecord() {
        if secondTimer == nil {
            secondTimer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(doSecondFunction), userInfo: nil, repeats: true)
            if let timerObj = secondTimer {
                RunLoop.current.add(timerObj, forMode: .common)
            }
            secondTimer?.fire()
        }
    }

    func endRecord() {
        if secondTimer != nil {
            secondTimer?.invalidate()
            secondTimer = nil
        }
    }

    func title() -> String {
        return ""
    }

    func lowValue() -> String {
        return "0"
    }

    func highValue() -> String {
        return "100"
    }

    @objc
    func doSecondFunction() {

    }

    override func viewWillTransition(to size: CGSize,
                                     with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        DispatchQueue.main.async {
            AssistantOscillogramWindowManager.shared.resetLayout()
        }
    }
}
