//
//  MLeaksFinderListViewController.swift
//  AppAssistant
//
//  Created by 王来 on 2020/11/20.
//

import UIKit

class MLeaksFinderListViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    private lazy var tab: UITableView = {

        let tab = UITableView(frame: view.bounds, style: .plain)
        tab.delegate = self
        tab.dataSource = self
        return tab
    }()

    var dataArray = MemoryLeakData.shared.getResult()

    override func viewDidLoad() {
        super.viewDidLoad()

        assistant_setNavBack()
        assistant_setNavTitle(localizedString("内存泄漏检测结果"))

        view.addSubview(tab)
    }

    // MARK: - UITableView Delegate
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataArray.count
    }

    private func tableView(_ tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return MLeaksFinderListCell.cellHeight()
    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0.001
    }

    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.001
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let identifer = "MLeaksFinderListCellID"
        var cell = tableView.dequeueReusableCell(withIdentifier: identifer)
        if cell == nil {
            cell = MLeaksFinderListCell(style: .default, reuseIdentifier: identifer)
        }
        if let dic = dataArray[indexPath.row] as? [String: Any], let cell = cell as? MLeaksFinderListCell {
            cell.renderCellWithData(dic: dic)
        }
        return cell ?? UITableViewCell()
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        let detail = MLeaksFinderDetailViewController()
        if let dic = dataArray[indexPath.row] as? [String: Any] {
            detail.info = dic
        }
        navigationController?.pushViewController(detail, animated: true)
    }
}
