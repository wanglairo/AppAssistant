//
//  AssistantMethodUseTimeListViewController.swift
//  AppAssistant
//
//  Created by wangbao on 2020/11/16.
//

import Foundation

class AssistantMethodUseTimeListViewController: UIViewController {

    var loadMoreArray = [Any]()

    override func viewDidLoad() {
        super.viewDidLoad()

        assistant_setNavTitle(localizedString("Load耗时检测记录"))

        loadMoreArray = AssistantMethodUseTimeManager.sharedInstance.fixLoadModeArray()
        self.view.addSubview(tableView)
        tableView.snp.makeConstraints { (maker) in
            maker.edges.equalTo(0)
        }
    }

    private lazy var tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .plain)
        tableView.delegate = self
        tableView.dataSource = self
        return tableView
    }()
}

extension AssistantMethodUseTimeListViewController: UITableViewDelegate, UITableViewDataSource {

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return loadMoreArray.count
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return AssistantMethodUseTimeListCell.cellHeight()
    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0.1
    }

    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.1
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellIdentifier = ""
        var listCell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier) as? AssistantMethodUseTimeListCell
        if listCell == nil {
            listCell = AssistantMethodUseTimeListCell(style: .default, reuseIdentifier: cellIdentifier)
        }
        let dic = loadMoreArray[indexPath.row]
        listCell?.renderCellWithData(dic: dic as? [String: Any] ?? ["": ""])
        return listCell ?? UITableViewCell()
    }
}
