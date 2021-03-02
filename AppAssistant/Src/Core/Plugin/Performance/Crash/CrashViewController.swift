//
//  CrashViewController.swift
//  AppAssistant
//
//  Created by 王来 on 2020/11/18.
//

import UIKit

class CrashViewController: UIViewController {

    private lazy var tableView: UITableView = {
        $0.rowHeight = 52
        $0.dataSource = self
        $0.delegate = self
        $0.register(CrashListCell.self, forCellReuseIdentifier: CrashListCell.identifier)
        return $0
    }( UITableView(frame: .zero, style: .plain) )

    private var rows: [Row] = [.switch(isOn: AssistantCacheManager.shared.crashSwitch()), .log, .clean]

    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }

    private func setup() {

        needBigTitleView = true
        assistant_setNavTitle(localizedString("Crash"))

        view.addSubview(tableView)
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        tableView.frame = CGRect(x: 0,
                                 y: CrashViewController.bigTitleViewH,
                                 width: view.assk.width,
                                 height: view.assk.height - CrashViewController.bigTitleViewH)
    }
}

// MARK: - UITableViewDataSource & UITableViewDelegate
extension CrashViewController: UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return rows.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: CrashListCell.identifier,
                                                 for: indexPath) as? CrashListCell

        let row = rows[indexPath.row]
        switch row {
        case .switch(let isOn):
            cell?.delegate = self
            cell?.set(.switch(isOn: isOn))
        default:
            cell?.set(.indicator)
        }
        cell?.set(text: row.title)
        return cell ?? UITableViewCell()
    }
}

extension CrashViewController: UITableViewDelegate {

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        switch rows[indexPath.row] {
        case .log:
            guard let url = try? Crash.Tool.directory() else {
                return
            }

            let controller = SandboxListViewController(url)
            controller.title = localizedString("Crash日志列表")
            navigationController?.pushViewController(controller, animated: true)

        case .clean:
            showAlert(
                title: localizedString("提示"),
                message: localizedString("确认删除所有崩溃日志吗？"),
                buttonTitles: [localizedString("取消"), localizedString("确定")]
            ) { [weak self] index in
                switch index {
                case 1:
                    do {
                        try FileManager.default.removeItem(at: Crash.Tool.directory())
                        ToastUtil.showToast("删除成功", superView: self?.view)
                    } catch {
                        ToastUtil.showToast("删除失败", superView: self?.view)
                    }

                default:
                    break
                }
            }

        case .switch:
            break
        }
    }
}

extension CrashViewController: CrashListCellDelegate {

    func switchAction(cell: CrashListCell, _ isOn: Bool, handle: @escaping (Bool) -> Void) {
        showAlert(
            title: localizedString("提示"),
            message: localizedString("该功能需要重启App才能生效"),
            buttonTitles: [localizedString("取消"), localizedString("确定")]
        ) { index in
            switch index {
            case 1:
                AssistantCacheManager.shared.saveCrashSwitch(isOn)
                handle(true)
                exit(0)

            default:
                handle(false)
            }
        }
    }
}

extension CrashViewController {

    enum Row {
        case `switch`(isOn: Bool)
        case log
        case clean

        var title: String {
            switch self {
            case .switch:       return localizedString("Crash日志收集开关")
            case .log:          return localizedString("查看Crash日志")
            case .clean:        return localizedString("一键清理Crash日志")
            }
        }
    }
}
