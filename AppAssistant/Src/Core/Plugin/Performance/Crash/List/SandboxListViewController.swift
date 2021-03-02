//
//  SandboxListViewController.swift
//  AppAssistant
//
//  Created by 王来 on 2020/11/17.
//

import UIKit

class SandboxListViewController: UIViewController {

    private lazy var tableView: UITableView = {
        $0.rowHeight = 52
        $0.dataSource = self
        $0.delegate = self
        $0.register(CrashListCell.self, forCellReuseIdentifier: CrashListCell.identifier)
        return $0
    }(UITableView(frame: .zero, style: .plain) )

    private var datas: [SandboxModel] = []

    private var url: URL?

    override func viewDidLoad() {
        super.viewDidLoad()

        setup()
        loadData()
    }

    private func setup() {

        assistant_setNavBack()
        assistant_setNavTitle("日志列表")
        view.addSubview(tableView)
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        tableView.frame = view.bounds
    }

    init(_ url: URL) {
        self.url = url
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

/// - Private
extension SandboxListViewController {

    private func loadData() {
        guard let url = url else {
            return
        }
        guard FileManager.default.fileExists(atPath: url.path) else {
            return
        }
        title = self.title ?? url.lastPathComponent

        loadPath(at: url)
    }

    private func loadPath(at url: URL) {
        DispatchQueue.global().async {
            do {
                let manager = FileManager.default
                let contents = try manager.contentsOfDirectory(atPath: url.path)
                typealias Item = (name: String, date: Date)
                let items: [Item] = try contents.compactMap {
                    let path = url.appendingPathComponent($0).path
                    let attributes = try manager.attributesOfItem(atPath: path)
                    guard let date = attributes[.creationDate] as? Date else {
                        return nil
                    }
                    return ($0, date)
                }

                let datas: [SandboxModel] = items.sorted { $0.date < $1.date }.map {
                    let complete = url.appendingPathComponent($0.name)
                    var isDirectory: ObjCBool = false
                    manager.fileExists(atPath: complete.path, isDirectory: &isDirectory)
                    switch isDirectory.boolValue {
                    case true:          return SandboxModel(name: $0.name, url: complete, type: .directory)
                    case false:         return SandboxModel(name: $0.name, url: complete, type: .file)
                    }
                }
                DispatchQueue.main.async {
                    self.datas = datas
                    self.tableView.reloadData()
                }
            } catch {
                print("失败\(error)")
            }
        }
    }

    private func handleFile(at url: URL) {
        let alert = UIAlertController(title: localizedString("请选择操作方式"), message: nil, preferredStyle: .actionSheet)
        let preview = UIAlertAction(title: localizedString("本地预览"), style: .default) { _ in

            let detail = SanboxDetailViewController(filePath: url.relativePath)
            self.navigationController?.pushViewController(detail, animated: true)
        }

        let share = UIAlertAction(title: localizedString("分享"), style: .default) { [weak self] _ in
            guard let self = self else {
                return
            }
            AssistantUtil.share(with: url, self)
        }

        let cancel = UIAlertAction(title: localizedString("取消"), style: .cancel)
        alert.addAction(preview)
        alert.addAction(share)
        alert.addAction(cancel)
        present(alert, animated: true)
    }
}

// MARK: - UITableViewDataSource & UITableViewDelegate
extension SandboxListViewController: UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return datas.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: CrashListCell.identifier,
                                                 for: indexPath) as? CrashListCell
        let item = datas[indexPath.row]
        cell?.set(text: "\(item.name)")
        return cell ?? UITableViewCell()
    }
}

extension SandboxListViewController: UITableViewDelegate {

    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }

    func tableView(_ tableView: UITableView, titleForDeleteConfirmationButtonForRowAt indexPath: IndexPath) -> String? {
        return localizedString("删除")
    }

    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        guard editingStyle == .delete else {
            return
        }
        let item = datas[indexPath.row]
        try? FileManager.default.removeItem(at: item.url)
        loadData()
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let item = datas[indexPath.row]
        switch item.type {
        case .file:
            handleFile(at: item.url)
        case .directory:
            let controller = SandboxListViewController(item.url)
            navigationController?.pushViewController(controller, animated: true)
        default:
            break
        }
    }
}
