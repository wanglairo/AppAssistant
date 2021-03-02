//
//  NetFlowSummaryTotalDataView.swift
//  Alamofire
//
//  Created by 王来 on 2020/10/19.
//

class NetFlowSummaryTotalDataItemView: UIView {

    private lazy var titleLabel: UILabel = {

        let titleLabel = UILabel()
        titleLabel.font = UIFont.regular(10)
        titleLabel.textColor = UIColor.assistant_black_2()
        titleLabel.textAlignment = .center
        return titleLabel
    }()

    private lazy var valueLabel: UILabel = {

        let titleLabel = UILabel()
        titleLabel.font = UIFont.regular(22)
        titleLabel.textColor = UIColor.assistant_black_1()
        titleLabel.textAlignment = .center
        return titleLabel
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)

        setUpUI()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func setUpUI() {

        addSubview(valueLabel)
        valueLabel.snp.makeConstraints {
            $0.top.right.left.equalToSuperview().offset(0)
        }

        addSubview(titleLabel)
        titleLabel.snp.makeConstraints {
            $0.right.left.equalToSuperview().offset(0)
            $0.top.equalTo(valueLabel.snp.bottom).offset(10.fitSizeFrom750)
        }
    }

    func renderUIWithTitle(_ title: String, value: String) {
        titleLabel.text = title
        valueLabel.text = value
    }

}

class NetFlowSummaryTotalDataView: UIView {

    /// 抓包时间
    private lazy var timeView: NetFlowSummaryTotalDataItemView = {
        let timeView = NetFlowSummaryTotalDataItemView()
        return timeView
    }()

    /// 抓包数量
    private lazy var numView: NetFlowSummaryTotalDataItemView = {
        let timeView = NetFlowSummaryTotalDataItemView()
        return timeView
    }()

    /// 数据上传
    private lazy var upLoadView: NetFlowSummaryTotalDataItemView = {
        let timeView = NetFlowSummaryTotalDataItemView()
        return timeView
    }()

    /// 数据下载
    private lazy var downLoadView: NetFlowSummaryTotalDataItemView = {
        let timeView = NetFlowSummaryTotalDataItemView()
        return timeView
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)

        setUpUI()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func setUpUI() {
        self.layer.cornerRadius = 5
        self.backgroundColor = UIColor.white

        addSubview(timeView)
        timeView.snp.makeConstraints {
            $0.top.equalToSuperview().offset(20.fitSizeFrom750)
            $0.centerX.equalToSuperview().offset(0)
            $0.height.equalTo(60.fitSizeFrom750)
        }

        addSubview(numView)
        numView.snp.makeConstraints {
            $0.left.bottom.equalToSuperview().offset(0)
            $0.width.equalToSuperview().multipliedBy(1.0 / 3.0)
            $0.height.equalTo(timeView.snp.height)
        }

        addSubview(upLoadView)
        upLoadView.snp.makeConstraints {
            $0.bottom.equalToSuperview().offset(0)
            $0.centerX.equalToSuperview().offset(0)
            $0.width.equalTo(numView.snp.width)
            $0.height.equalTo(timeView.snp.height)
        }

        addSubview(downLoadView)
        downLoadView.snp.makeConstraints {
            $0.right.bottom.equalToSuperview().offset(0)
            $0.width.equalTo(numView.snp.width)
            $0.height.equalTo(timeView.snp.height)
        }

        // 抓包时间
        var time = ""
        if let startInterceptDate = NetFlowManager.shared.startInterceptDate {
            let nowDate = Date()
            let cha = nowDate.timeIntervalSince(startInterceptDate as Date)
            time = String(format: "%.2f%@", cha, "秒")
        } else {
            time = "暂未开启网络监控"
        }
        timeView.renderUIWithTitle("总计已为您抓包", value: time)

        // 抓包数量
        let httpModelArray: [NetFlowHttpModel] = NetFlowDataSource.shared.httpModelArray
        let num = "\(httpModelArray.count)"
        var totalUploadFlow = 0
        var totalDownFlow = 0
        for index in 0..<httpModelArray.count {
            let httpModel = httpModelArray[index]
            let uploadFlow = NSString(string: httpModel.uploadFlow ?? "").intValue
            let downFlow = NSString(string: httpModel.downFlow ?? "").intValue
            totalUploadFlow += Int(uploadFlow)
            totalDownFlow += Int(downFlow)
        }
        numView.renderUIWithTitle("抓包数量", value: num)

        // 数据上传
        let upLoad = AssistantUtil.formatByte(Float(totalUploadFlow))
        upLoadView.renderUIWithTitle("数据上传", value: upLoad)

        // 数据下载
        let downLoad = AssistantUtil.formatByte(Float(totalDownFlow))
        downLoadView.renderUIWithTitle("数据下载", value: downLoad)
    }

}
