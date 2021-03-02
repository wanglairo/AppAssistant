//
//  AssistantANRListViewController.swift
//  AppAssistant
//
//  Created by wangbao on 2020/11/2.
//

import Foundation

class AssistantANRListViewController: UIViewController {

    var dataSource = [String]()

    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.backgroundColor = .white
        loadANRData()
        assistant_setNavTitle(localizedString("卡顿列表"))
        self.view.addSubview(tableView)
        tableView.snp.makeConstraints { (maker) in
            maker.edges.equalTo(0)
        }
    }

    func loadANRData() {
        let manager = FileManager.default
        let anrDirectory = AssistantANRTool.anrDirectory()
        guard anrDirectory.isEmpty == false && manager.fileExists(atPath: anrDirectory) else {
            return
        }
        guard var paths = try? manager.contentsOfDirectory(atPath: anrDirectory) else {
            return
        }
        paths.sort { (obj1, obj2) -> Bool in
            let path1 = (anrDirectory as NSString).appendingPathComponent(obj1)
            let path2 = (anrDirectory as NSString).appendingPathComponent(obj2)
            let info1 = try? manager.attributesOfItem(atPath: path1)
            let info2 = try? manager.attributesOfItem(atPath: path2)

            if let vbj1 = info1?[FileAttributeKey.creationDate] as? Date, let vbj2 = info2?[FileAttributeKey.creationDate] as? Date {
                return vbj1.timeIntervalSince(vbj2) > 0
            }
            return true
        }
        dataSource = paths
        tableView.reloadData()
    }

    private lazy var tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .plain)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.tableFooterView = UIView()
        return tableView
    }()
}

extension AssistantANRListViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource.count
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return AssistantANRListCell.cellHeight()
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let identifier = "AssistantANRListCell"
        var listViewCell: AssistantANRListCell? = tableView.dequeueReusableCell(withIdentifier: identifier) as? AssistantANRListCell
        if listViewCell == nil {
            listViewCell = AssistantANRListCell(style: .default, reuseIdentifier: identifier)
        }
        listViewCell?.renderCell(title: dataSource[indexPath.row])
        return listViewCell ?? AssistantANRListCell()
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        if indexPath.row < dataSource.count {
            let path = dataSource[indexPath.row]
            let fullPath = (AssistantANRTool.anrDirectory() as NSString).appendingPathComponent(path)
            let detailVc = AssistantANRDetailViewController()
            detailVc.filePath = fullPath
            navigationController?.pushViewController(detailVc, animated: true)
        }
    }

    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }

    func tableView(_ tableView: UITableView, titleForDeleteConfirmationButtonForRowAt indexPath: IndexPath) -> String? {
        return localizedString("删除")
    }

    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if indexPath.row < dataSource.count {
            let fullPath = (AssistantANRTool.anrDirectory() as NSString).appendingPathComponent(dataSource[indexPath.row])
            try? FileManager.default.removeItem(atPath: fullPath)
            loadANRData()
        }
    }
}
