//
//  EnvironmentViewController.swift
//  scaffold
//
//  Created by zhaochangwu on 2021/1/13.
//

import UIKit

class EnvironmentViewController: UIViewController {

    private lazy var tableView: UITableView = {

        let tableView = UITableView(frame: .zero, style: .grouped)
        tableView.backgroundColor = UIColor.assistant_bg()
        tableView.register(AssistantAppInfoCell.self, forCellReuseIdentifier: "AssistantAppInfoCell")
        tableView.delegate = self
        tableView.dataSource = self
        tableView.estimatedRowHeight = 0
        tableView.estimatedSectionFooterHeight = 0
        tableView.estimatedSectionHeaderHeight = 0
        return tableView
    }()

    var dataArray: [[String: Any]] = []

    override func viewDidLoad() {
        super.viewDidLoad()

        initUI()
    }

    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
    }

    func initUI() {

        self.needBigTitleView = true
        self.assistant_setNavTitle(localizedString("选择环境"))

        self.view.addSubview(tableView)
        tableView.snp.makeConstraints({ (maker) in
            maker.left.right.bottom.equalTo(0)
            maker.top.equalTo(AssistantAppInfoViewController.bigTitleViewH)
        })
    }
}

extension EnvironmentViewController: UITableViewDelegate, UITableViewDataSource {

    func numberOfSections(in tableView: UITableView) -> Int {
        return dataArray.count
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let data = dataArray[section]
        let array = data["array"] as? [[String: Any]]
        return array?.count ?? 0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let IDcell = "AssistantAppInfoCell"
        var listViewCell: AssistantAppInfoCell? = tableView.dequeueReusableCell(withIdentifier: IDcell) as? AssistantAppInfoCell
        if listViewCell == nil {
            listViewCell = UITableViewCell(style: .default, reuseIdentifier: IDcell) as? AssistantAppInfoCell
        }
        let array = dataArray[indexPath.section]["array"] as? [ [String: String]]
        let item = array?[indexPath.row] ?? ["": ""]
        listViewCell?.renderUIWithData(data: item)
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
        let dic = dataArray[section]
        titleLabel.text = dic["title"] as? String ?? ""
        titleLabel.font = UIFont.systemFont(ofSize: 28.fitSizeFrom750Landscape)
        titleLabel.textColor = UIColor.assistant_black_3()
        sectionView.addSubview(titleLabel)
        return sectionView
    }

    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.1
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        guard let array = dataArray[indexPath.section]["array"] as? [[String: Any]] else {
            return
        }
        AssistantManager.shared.switchEnvBlock?(array[indexPath.row]["title"] as? String ?? "")
    }
}
