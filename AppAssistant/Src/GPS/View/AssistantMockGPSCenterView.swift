//
//  AssistantMockGPSCenterView.swift
//  AppAssistant
//
//  Created by wangbao on 2020/10/12.
//

import Foundation

class AssistantMockGPSCenterView: UIView {

    override init(frame: CGRect) {
        super.init(frame: frame)

        self.addSubview(circleView)
        self.addSubview(locationIconView)
        self.addSubview(gpsLabel)
        self.addSubview(arrowImageView)

        circleView.snp.makeConstraints({ (maker) in
            maker.left.equalTo(self.snp_centerX).offset(-50.fitSizeFrom750Landscape)
            maker.top.equalTo(self.snp_centerY).offset(-50.fitSizeFrom750Landscape)
            maker.width.height.equalTo(100.fitSizeFrom750Landscape)
        })

        locationIconView.snp.makeConstraints({ (maker) in
            maker.centerX.equalTo(circleView.snp.centerX)
            maker.bottom.equalTo(circleView.snp.centerY)
        })

        arrowImageView.snp.makeConstraints { (maker) in
            maker.centerX.equalTo(gpsLabel.snp.centerX)
            maker.bottom.equalTo(locationIconView.snp.top).offset(-20.fitSizeFrom750Landscape)
        }

        gpsLabel.snp.makeConstraints { (maker) in
            maker.bottom.equalTo(arrowImageView.snp.top).offset(10.fitSizeFrom750Landscape)
            maker.centerX.equalTo(self.snp.centerX)
        }
    }

    lazy var circleView: UIView = {
        let circleView = UIView()
        circleView.layer.cornerRadius = 50.fitSizeFrom750Landscape
        circleView.backgroundColor = UIColor.assistant_colorWithHex(0xFFA511, andAlpha: 0.37)
        return circleView
    }()

    lazy var gpsLabel: UILabel = {
        let gpsLabel = UILabel()
        gpsLabel.textColor = UIColor.assistant_black_1()
        gpsLabel.font = UIFont.systemFont(ofSize: 24.fitSizeFrom750Landscape)
        gpsLabel.backgroundColor = UIColor.white
        gpsLabel.textAlignment = .center
        gpsLabel.layer.cornerRadius = 12.fitSizeFrom750Landscape
        gpsLabel.clipsToBounds = true

        return gpsLabel
    }()

    lazy var locationIconView: UIImageView = {
        let locationIconView = UIImageView(image: UIImage.assistant_xcassetImageNamed(name: "doraemon_location"))
        return locationIconView
    }()

    lazy var arrowImageView: UIImageView = {
        let arrowImageView = UIImageView(image: UIImage.assistant_xcassetImageNamed(name: "doraemon_arrow_down"))
        return arrowImageView
    }()

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func renderUIWithGPS(_ gps: String) {
        gpsLabel.text = gps
    }

    func hiddenGPSInfo(_ hidden: Bool) {
        gpsLabel.isHidden = hidden
        arrowImageView.isHidden = hidden
    }

    override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        let hitView = super.hitTest(point, with: event)
        if hitView == self {
            return nil
        }
        return hitView
    }

}
