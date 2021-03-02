//
//  NetFlowListCell.swift
//  Alamofire
//
//  Created by 王来 on 2020/10/20.
//

import UIKit

class NetFlowListCell: UITableViewCell {

    static let reuseIdentifier = "NetFlowListCell"

    // url信息
    private lazy var urlLabel: UILabel = {

        let label = UILabel()
        label.font = UIFont.regular(10)
        label.textColor = UIColor.assistant_black_2()
        label.textAlignment = .center
        return label
    }()

    // 请求方式
    private lazy var methodLabel: UILabel = {

        let label = UILabel()
        label.font = UIFont.regular(10)
        label.textColor = UIColor.assistant_black_2()
        label.textAlignment = .center
        return label
    }()

    // 请求状态
    private lazy var statusLabel: UILabel = {

        let label = UILabel()
        label.font = UIFont.regular(10)
        label.textColor = UIColor.assistant_black_2()
        label.textAlignment = .center
        return label
    }()

    // 请求开始时间
    private lazy var startTimeLabel: UILabel = {

        let label = UILabel()
        label.font = UIFont.regular(10)
        label.textColor = UIColor.assistant_black_2()
        label.textAlignment = .center
        return label
    }()

    // 请求耗时
    private lazy var timeLabel: UILabel = {

        let label = UILabel()
        label.font = UIFont.regular(10)
        label.textColor = UIColor.assistant_black_2()
        label.textAlignment = .center
        return label
    }()

    // 流量信息
    private lazy var flowLabel: UILabel = {

        let label = UILabel()
        label.font = UIFont.regular(10)
        label.textColor = UIColor.assistant_black_2()
        label.textAlignment = .center
        return label
    }()

    private lazy var arrowImageView: UIImageView = {

        let arrowImageView = UIImageView(image: UIImage.assistant_xcassetImageNamed(name: "doraemon_mock_detail_up"))
        return arrowImageView
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setUpUI()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func setUpUI() {

        contentView.backgroundColor = UIColor.white

        addSubview(urlLabel)
        urlLabel.snp.makeConstraints {
            $0.top.equalToSuperview().offset(0)
            $0.left.equalToSuperview().offset(10.fitSizeFrom750)
        }

        addSubview(methodLabel)
        methodLabel.snp.makeConstraints {
            $0.left.equalTo(urlLabel.snp.left).offset(0)
            $0.top.equalTo(urlLabel.snp.bottom).offset(0)
        }

        addSubview(statusLabel)
        statusLabel.snp.makeConstraints {
            $0.left.equalTo(methodLabel.snp.right).offset(10.fitSizeFrom750)
            $0.centerY.equalTo(methodLabel.snp.centerY).offset(0)
        }

        addSubview(startTimeLabel)
        startTimeLabel.snp.makeConstraints {
            $0.left.equalTo(urlLabel.snp.left).offset(0)
            $0.top.equalTo(methodLabel.snp.bottom).offset(0)
        }

        addSubview(timeLabel)
        timeLabel.snp.makeConstraints {
            $0.left.equalTo(startTimeLabel.snp.right).offset(0)
            $0.centerY.equalTo(startTimeLabel.snp.centerY).offset(0)
        }

        addSubview(flowLabel)
        flowLabel.snp.makeConstraints {
            $0.left.equalTo(urlLabel.snp.left).offset(0)
            $0.top.equalTo(timeLabel.snp.bottom).offset(0)
        }

        addSubview(arrowImageView)
        arrowImageView.snp.makeConstraints {
            $0.centerY.equalToSuperview().offset(0)
            $0.right.equalToSuperview().offset(-10.fitSizeFrom750)
        }

    }

    func renderCellWithModel(httpModel: NetFlowHttpModel) {

        urlLabel.text = httpModel.url

        if let mineType = httpModel.mineType, !mineType.isEmpty {
            methodLabel.text = httpModel.method ?? "" + " > " + mineType
        } else {
            methodLabel.text = httpModel.method
        }

        statusLabel.text = httpModel.statusCode
        startTimeLabel.text = AssistantUtil.dateFormatTimeInterval(httpModel.startTime ?? 0)
        timeLabel.text = String(format: " %@ : %@s", "耗时", httpModel.totalDuration ?? "")

        let uploadFl = NSString(string: httpModel.uploadFlow ?? "").floatValue
        let uploadFlow = AssistantUtil.formatByte(uploadFl)

        let downFl = NSString(string: httpModel.downFlow ?? "").floatValue
        let downFlow = AssistantUtil.formatByte(downFl)

        flowLabel.text = " ↑ \(uploadFlow) " + " ↓ \(downFlow) "
    }

}
