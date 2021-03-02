//
//  DemoHomeController.swift
//  AppAssistant_Example
//
//  Created by 王来 on 2020/10/22.
//  Copyright © 2020 CocoaPods. All rights reserved.
//

import AppAssistant

class DemoHomeController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    var tableView: UITableView!
    var items: [String]! = [] {
        didSet {
            self.tableView.reloadData()
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = "AssistantKit"
        view.backgroundColor = .white

        tableView = UITableView(frame: view.bounds)
        tableView.backgroundColor = .white
        tableView.delegate = self
        tableView.dataSource = self
        view.addSubview(tableView)

        items = ["网络测试Demo",
                 "模拟位置Demo",
                 "crash触发Demo",
                 "内存泄漏测试"]
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: "HomeCellId")
        if cell == nil {
            cell = UITableViewCell(style: .default, reuseIdentifier: "HomeCellId")
        }
        cell?.backgroundColor = .white
        cell?.textLabel?.text = items[indexPath.row]
        cell?.textLabel?.textColor = .black

        return cell ?? UITableViewCell()
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let row = indexPath.row
        var vc = UIViewController()
        switch row {
        case 0:
            vc = DemoNetViewController()
        case 1:
            vc = DoraemonDemoGPSViewController()
        case 2:
            vc = DemoCrashViewController()
        case 3:
            vc = DemoMemoryLeakViewController()
        default:
            break
        }
        navigationController?.pushViewController(vc, animated: true)
    }

}
