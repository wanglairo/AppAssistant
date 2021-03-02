//
//  NetFlowInfoController.swift
//  AppAssistant
//
//  Created by 王来 on 2020/10/20.
//

import UIKit

class NetFlowInfoController: UIViewController {

    var httpModel: NetFlowHttpModel?

    private lazy var tab: UITableView = {

        let tab = UITableView(frame: .zero, style: .grouped)
        tab.separatorStyle = .none
        tab.delegate = self
        tab.dataSource = self
        tab.backgroundColor = .clear
        tab.register(NetFlowInfoCell.self, forCellReuseIdentifier: NetFlowInfoCell.reuseIdentifier)
        return tab
    }()

    private lazy var topView: TopView = {

        let topView = TopView()
        topView.delegate = self
        return topView
    }()

    private var selectedSegmentIndex = NetFlowSelectState.request

    private var requestArray = [[String: Any]]()

    private var responseArray = [[String: Any]]()

    private let sectionTitleKey = "sectionTitleKey"

    private let dataArrayKey = "dataArrayKey"

    override func viewDidLoad() {
        super.viewDidLoad()

        setUpUI()
        initData()
    }

    func setUpUI() {

        assistant_setNavTitle("网络监控详情")
        view.backgroundColor = UIColor.assistant_bg()
        assistant_setNavBack()

        view.addSubview(topView)
        topView.snp.makeConstraints {
            $0.top.left.right.equalToSuperview()
            $0.height.equalTo(40.fitSizeFrom750)
        }

        view.addSubview(tab)
        tab.snp.makeConstraints {
            $0.top.equalTo(topView.snp.bottom).offset(0)
            $0.bottom.left.right.equalToSuperview()
        }
    }

    func initData() {

        let uploadFl = NSString(string: httpModel?.uploadFlow ?? "").floatValue
        let uploadFlow = AssistantUtil.formatByte(uploadFl)
        let requestDataSize = String(format: "数据大小 : %@", uploadFlow)

        var methodStr = ""
        if let method = httpModel?.method {
            methodStr = "Method : " + method
        }

        let linkUrl = httpModel?.url

        var allHTTPHeaderString = ""

        httpModel?.request?.allHTTPHeaderFields?.forEach({ (key, value) in
            allHTTPHeaderString.append("\(key) : \(value)\r\n")
        })

        let requestBody = httpModel?.requestBody

        requestArray = [
                         [sectionTitleKey: "请求概要",
                          dataArrayKey: [requestDataSize, methodStr]
                         ],
                         [sectionTitleKey: "链接",
                          dataArrayKey: [linkUrl]
                         ],
                         [sectionTitleKey: "请求头",
                          dataArrayKey: [allHTTPHeaderString]
                         ],
                         [sectionTitleKey: "请求体",
                          dataArrayKey: [requestBody]
                         ]
        ]

        let downFl = NSString(string: httpModel?.downFlow ?? "").floatValue
        let downFlow = AssistantUtil.formatByte(downFl)
        let respanseDataSize = String(format: "数据大小 : %@", downFlow)

        var mineTypeStr = ""
        if let mineType = httpModel?.mineType {
            mineTypeStr = "mineType :" + mineType
        }

        var responseHeaderString = ""
        httpModel?.request?.allHTTPHeaderFields?.forEach({ (key, value) in
            responseHeaderString.append("\(key) : \(value)\r\n")
        })

        let responseBody = httpModel?.responseBody

        responseArray = [
                         [sectionTitleKey: "响应概要",
                          dataArrayKey: [respanseDataSize, mineTypeStr]
                         ],
                         [sectionTitleKey: "响应头",
                          dataArrayKey: [responseHeaderString]
                         ],
                         [sectionTitleKey: "响应体",
                          dataArrayKey: [responseBody]
                         ]
        ]
    }

}

extension NetFlowInfoController: UITableViewDelegate, UITableViewDataSource {

    func numberOfSections(in tableView: UITableView) -> Int {
        return selectedSegmentIndex == NetFlowSelectState.request ? requestArray.count : responseArray.count
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        let sectionArray = selectedSegmentIndex == NetFlowSelectState.request ? requestArray : responseArray

        let rowsDic = sectionArray[section]
        let itemArray = rowsDic[dataArrayKey] as? [String]

        return itemArray?.count ?? 0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let sectionArray = selectedSegmentIndex == NetFlowSelectState.request ? requestArray : responseArray

        let rowsDic = sectionArray[indexPath.section]
        let itemArray = rowsDic[dataArrayKey] as? [String]

        let item = itemArray?[indexPath.row]

        let cell = tab.dequeueReusableCell(withIdentifier: NetFlowInfoCell.reuseIdentifier, for: indexPath) as? NetFlowInfoCell
        cell?.contentText = item
        return cell ?? UITableViewCell()
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {

        let sectionArray = selectedSegmentIndex == NetFlowSelectState.request ? requestArray : responseArray

        let rowsDic = sectionArray[indexPath.section]
        let itemArray = rowsDic[dataArrayKey] as? [String]

        let item = itemArray?[indexPath.row] ?? ""

        return NetFlowInfoCell.cellHeightWithContent(content: item)
    }

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {

        let sectionArray = selectedSegmentIndex == NetFlowSelectState.request ? requestArray : responseArray

        let rowsDic = sectionArray[section]
        let title = rowsDic[sectionTitleKey] as? String

        let headerView = UIView(frame: CGRect(x: 0, y: 0, width: screenWidth, height: 50.fitSizeFrom750))
        headerView.backgroundColor = .white

        let tipLabel = UILabel(frame: CGRect(x: 10.fitSizeFrom750, y: 0, width: screenWidth, height: 50.fitSizeFrom750))
        tipLabel.text = title
        tipLabel.font = UIFont.medium(16)
        tipLabel.textColor = UIColor.assistant_colorWithHexString("337CC4")

        headerView.addSubview(tipLabel)

        return headerView
    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50.fitSizeFrom750
    }

    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }

    func tableView(_ tableView: UITableView, titleForDeleteConfirmationButtonForRowAt indexPath: IndexPath) -> String? {
        return "复制"
    }

    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {

        let sectionArray = selectedSegmentIndex == NetFlowSelectState.request ? requestArray : responseArray

        let rowsDic = sectionArray[indexPath.section]
        let itemArray = rowsDic[dataArrayKey] as? [String]

        let content = itemArray?[indexPath.row]

        let pboard = UIPasteboard.general
        pboard.string = content
    }
}

extension NetFlowInfoController: TopViewDelegate {

    func itemClick(index: NetFlowSelectState) {
        selectedSegmentIndex = index
        tab.reloadData()
    }

}

extension NetFlowInfoController {

    class TopView: UIView {

        private lazy var leftBtn: UIButton = {

            let btn = UIButton(type: .custom)
            btn.setTitle("请求", for: .normal)
            btn.setTitleColor(UIColor.assistant_colorWithHexString("337CC4"), for: .selected)
            btn.setTitleColor(UIColor.assistant_colorWithHexString("333333"), for: .normal)
            btn.titleLabel?.font = UIFont.medium(16)
            btn.addTarget(self, action: #selector(btnClick(btn:)), for: .touchUpInside)
            return btn
        }()

        private lazy var rightBtn: UIButton = {

            let btn = UIButton(type: .custom)
            btn.setTitle("响应", for: .normal)
            btn.setTitleColor(UIColor.assistant_colorWithHexString("337CC4"), for: .selected)
            btn.setTitleColor(UIColor.assistant_colorWithHexString("333333"), for: .normal)
            btn.titleLabel?.font = UIFont.medium(16)
            btn.addTarget(self, action: #selector(btnClick(btn:)), for: .touchUpInside)
            return btn
        }()

        weak var delegate: TopViewDelegate?

        override init(frame: CGRect) {
            super.init(frame: frame)

            setUpUI()
        }

        required init?(coder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }

        func setUpUI() {

            backgroundColor = .white

            addSubview(leftBtn)
            leftBtn.snp.makeConstraints {
                $0.left.top.bottom.equalToSuperview().offset(0)
                $0.width.equalToSuperview().multipliedBy(0.5)
            }

            addSubview(rightBtn)
            rightBtn.snp.makeConstraints {
                $0.right.top.bottom.equalToSuperview().offset(0)
                $0.width.equalToSuperview().multipliedBy(0.5)
            }

            btnClick(btn: leftBtn)
        }

        @objc
        func btnClick(btn: UIButton) {

            leftBtn.isSelected = (btn == leftBtn)
            rightBtn.isSelected = !(btn == leftBtn)

            delegate?.itemClick(index: (btn == leftBtn) ? .request: .response)
        }
    }

}

enum NetFlowSelectState {
    case request
    case response
}

protocol TopViewDelegate: NSObjectProtocol {

    func itemClick(index: NetFlowSelectState)
}
