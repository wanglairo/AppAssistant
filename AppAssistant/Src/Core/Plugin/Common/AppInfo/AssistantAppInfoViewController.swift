//
//  AssistantAppInfoViewController.swift
//  AppAssistant
//
//  Created by wangbao on 2020/9/30.
//

import CoreTelephony
import Foundation

class AssistantAppInfoViewController: UIViewController {

    var tableView: UITableView?

    var dataArray: [[String: Any]]?

    var authority = ""

    var cellularData: CTCellularData?

    override func viewDidLoad() {
        super.viewDidLoad()

        initUI()
        initData()
    }

    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        if #available(iOS 9.0, *) {
            cellularData?.cellularDataRestrictionDidUpdateNotifier = nil
            cellularData = nil
        }
    }

    func initUI() {

        self.needBigTitleView = true
        self.assistant_setNavTitle(localizedString("App Info"))

        tableView = UITableView(frame: .zero, style: .grouped)
//        if #available(iOS 13, *) {
//            tableView?.backgroundColor = UIColor.systemBackground
//        } else {
            tableView?.backgroundColor = UIColor.assistant_bg()
//        }
        tableView?.register(AssistantAppInfoCell.self, forCellReuseIdentifier: "AssistantAppInfoCell")
        tableView?.delegate = self
        tableView?.dataSource = self
        tableView?.estimatedRowHeight = 0
        tableView?.estimatedSectionFooterHeight = 0
        tableView?.estimatedSectionHeaderHeight = 0
        self.view.addSubview(tableView ?? UITableView())
        tableView?.snp.makeConstraints({ (maker) in
            maker.left.right.bottom.equalTo(0)
            maker.top.equalTo(AssistantAppInfoViewController.bigTitleViewH)
        })
    }

    func configCellularData() {
        if #available(iOS 9.0, *) {
            cellularData = CTCellularData()
            cellularData?.cellularDataRestrictionDidUpdateNotifier = { [weak self] (state) in

                guard let self = self else {
                    return
                }
                switch state {
                case .restricted:
                    self.authority = "Restricted"
                case .notRestricted:
                    self.authority = "NotRestricted"
                default:
                    self.authority = "Unknown"
                }
                DispatchQueue.main.async {
                    self.tableView?.reloadData()
                }
            }
        }
    }

    func initData() {
        let appInfos = [
            ["title": "Bundle ID",
             "value": AssistantAppInfoUtil.bundleIdentifier()],
            ["title": "version",
             "value": AssistantAppInfoUtil.bundleVersion()],
            ["title": "VersionCode",
             "value": AssistantAppInfoUtil.bundleShortVersionString()]
        ]

        dataArray = [
            ["title": "手机信息",
             "array": [
                ["title": "设备名称",
                 "value": AssistantAppInfoUtil.iphoneName()],
                ["title": "手机型号",
                 "value": AssistantAppInfoUtil.iphoneType()],
                ["title": "系统版本",
                 "value": AssistantAppInfoUtil.iphoneSystemVersion()],
                ["title": "手机屏幕",
                 "value": String(format: "%.0f * %.0f", screenWidth, screenHeight)],
                ["title": "ipV4",
                 "value": AssistantAppInfoUtil.getIPAddress(true)],
                ["title": "ipV6",
                 "value": AssistantAppInfoUtil.getIPAddress(false)]
             ]
            ],
            ["title": "App Info",
             "array": appInfos],
            ["title": "权限信息",
             "array": [
                ["title": "地理位置权限",
                 "value": AssistantAppInfoUtil.locationAuthority()],
                ["title": "网络权限",
                 "value": "Unknown"],
                ["title": "推送权限",
                 "value": AssistantAppInfoUtil.pushAuthority()],
                ["title": "相机权限",
                 "value": AssistantAppInfoUtil.cameraAuthority()],
                ["title": "麦克风权限",
                 "value": AssistantAppInfoUtil.audioAuthority()],
                ["title": "相册权限",
                 "value": AssistantAppInfoUtil.photoAuthority()],
                ["title": "通讯录权限",
                 "value": AssistantAppInfoUtil.addressAuthority()],
                ["title": "日历权限",
                 "value": AssistantAppInfoUtil.calendarAuthority()],
                ["title": "提醒事项权限",
                 "value": AssistantAppInfoUtil.remindAuthority()]
             ]
            ]
        ]
        configCellularData()
    }
}

extension AssistantAppInfoViewController: UITableViewDelegate, UITableViewDataSource {

    func numberOfSections(in tableView: UITableView) -> Int {
        return dataArray?.count ?? 0
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let data = dataArray?[section]
        let array = data?["array"] as? [[String: Any]]
        return array?.count ?? 0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let IDcell = "AssistantAppInfoCell"
        var listViewCell: AssistantAppInfoCell? = tableView.dequeueReusableCell(withIdentifier: IDcell) as? AssistantAppInfoCell
        if listViewCell == nil {
            listViewCell = UITableViewCell(style: .default, reuseIdentifier: IDcell) as? AssistantAppInfoCell
        }
        let array = dataArray?[indexPath.section]["array"] as? [ [String: String]]
        let item = array?[indexPath.row] ?? ["": ""]
        if indexPath.section == 2, indexPath.row == 1, authority.isEmpty == false {
            let tempItem = NSMutableDictionary(dictionary: item)
            tempItem.setValue(self.authority, forKey: "value")
            listViewCell?.renderUIWithData(data: tempItem as? [String: String] ?? ["": ""])
        } else {
            listViewCell?.renderUIWithData(data: item)
        }
        return listViewCell ?? AssistantAppInfoCell()
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return AssistantAppInfoCell.cellHeight()
    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 120.fitSizeFrom750Landscape
    }

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let sectionView = UIView(frame: CGRect(x: 0, y: 0, width: screenWidth, height: 120.fitSizeFrom750Landscape))
        let titleLabel = UILabel(frame: CGRect(x: 32.fitSizeFrom750Landscape,
                                               y: 0,
                                               width: screenWidth - 32.fitSizeFrom750Landscape,
                                               height: 120.fitSizeFrom750Landscape))
        let dic = dataArray?[section]
        titleLabel.text = dic?["title"] as? String ?? ""
        titleLabel.font = UIFont.systemFont(ofSize: 28.fitSizeFrom750Landscape)
        titleLabel.textColor = UIColor.assistant_black_3()
        sectionView.addSubview(titleLabel)
        return sectionView
    }

    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.1
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

    }

    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }

    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let action0 = UITableViewRowAction(style: .default, title: "复制") { (_, indexPath) in
            let array = self.dataArray?[indexPath.section]["array"] as? [ [String: String]]
            let item = array?[indexPath.row] ?? ["": ""]
            let value = item["value"]
            let pboard = UIPasteboard.general
            pboard.string = value
        }
        return [action0]
    }
}
