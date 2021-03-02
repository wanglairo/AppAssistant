//
//  NetFlowListViewController.swift
//  Alamofire
//
//  Created by 王来 on 2020/10/19.
//

class NetFlowListViewController: UIViewController {

    private lazy var tab: UITableView = {

        let tab = UITableView(frame: .zero, style: .plain)
        tab.delegate = self
        tab.dataSource = self
        tab.backgroundColor = .clear
        tab.register(NetFlowListCell.self, forCellReuseIdentifier: NetFlowListCell.reuseIdentifier)
        return tab
    }()

    var dataArray = NetFlowDataSource.shared.httpModelArray

    override func viewDidLoad() {
        super.viewDidLoad()
        setUpUI()
    }

    func setUpUI() {

        assistant_setNavTitle("网络监控列表")
        view.backgroundColor = UIColor.assistant_bg()
        assistant_setNavBack()

        view.addSubview(tab)
        tab.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }

}

extension NetFlowListViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataArray.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let cell = tab.dequeueReusableCell(withIdentifier: NetFlowListCell.reuseIdentifier, for: indexPath) as? NetFlowListCell
        cell?.renderCellWithModel(httpModel: dataArray[indexPath.row])
        return cell ?? UITableViewCell()
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60.fitSizeFrom750
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        let netFlowInfoVC = NetFlowInfoController()
        netFlowInfoVC.httpModel = dataArray[indexPath.row]
        navigationController?.pushViewController(netFlowInfoVC, animated: true)
    }

}
