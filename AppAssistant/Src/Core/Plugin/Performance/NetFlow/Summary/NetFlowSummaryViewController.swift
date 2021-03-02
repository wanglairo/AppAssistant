//
//  NetFlowSummaryViewController.swift
//  Alamofire
//
//  Created by 王来 on 2020/10/19.
//

class NetFlowSummaryViewController: UIViewController {

    lazy var totalDataView: NetFlowSummaryTotalDataView = {
        let totalDataView = NetFlowSummaryTotalDataView()
        return totalDataView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        setUpUI()
    }

    func setUpUI() {

        view.backgroundColor = UIColor.assistant_bg()
        assistant_setNavBack()
        assistant_setNavTitle("网络监控摘要")

        view.addSubview(totalDataView)
        totalDataView.snp.makeConstraints {
            $0.top.equalToSuperview().offset(20.fitSizeFrom750)
            $0.left.equalToSuperview().offset(10.fitSizeFrom750)
            $0.right.equalToSuperview().offset(-10.fitSizeFrom750)
            $0.height.equalTo(160.fitSizeFrom750)
        }
    }

}
