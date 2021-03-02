//
//  NetFlowViewController.swift
//  Alamofire
//
//  Created by 王来 on 2020/10/16.
//

class NetFlowViewController: UIViewController {

    private lazy var switchLabel: UILabel = {

        let label = UILabel()
        label.font = UIFont.regular(16)
        label.textColor = UIColor.assistant_black_1()
        label.numberOfLines = 0
        label.text = "网络检测开关"
        return label
    }()

    private lazy var switchView: UISwitch = {

        let switchView = UISwitch()
        switchView.isOn = AssistantCacheManager.shared.netFlowSwitch()
        switchView.onTintColor = UIColor.assistant_blue()
        switchView.addTarget(self, action: #selector(switchAction(_:)), for: UIControl.Event.valueChanged)
        return switchView
    }()

    private lazy var lineView1: UIView = {

        let lineView = UIView()
        lineView.backgroundColor = UIColor.assistant_line()
        return lineView
    }()

    private lazy var lineView2: UIView = {

        let lineView = UIView()
        lineView.backgroundColor = UIColor.assistant_line()
        return lineView
    }()

    private lazy var showNetFlowDetailBtn: UIButton = {

        let btn = UIButton(type: .custom)
        btn.setTitle("显示网络检测详情", for: .normal)
        btn.setTitleColor(UIColor.white, for: .normal)
        btn.backgroundColor = UIColor.assistant_blue()
        btn.layer.cornerRadius = 4
        btn.addTarget(self, action: #selector(detailBtnAction(_:)), for: .touchUpInside)
        return btn
    }()

    private var tabBar = UITabBarController()

    override func viewDidLoad() {
        super.viewDidLoad()
        setUpUI()
    }

    func setUpUI() {

        self.view.backgroundColor = UIColor.assistant_bg()

        needBigTitleView = true
        assistant_setNavTitle("网络监控")

        view.addSubview(switchLabel)
        switchLabel.snp.makeConstraints {
            $0.top.equalToSuperview().offset(UIViewController.bigTitleViewH + 20.fitSizeFrom750)
            $0.left.equalToSuperview().offset(15.fitSizeFrom750)
        }

        view.addSubview(switchView)
        switchView.snp.makeConstraints {
            $0.right.equalToSuperview().offset(-15.fitSizeFrom750)
            $0.centerY.equalTo(switchLabel.snp.centerY).offset(0)
        }

        view.addSubview(lineView1)
        lineView1.snp.makeConstraints {
            $0.top.equalToSuperview().offset(UIViewController.bigTitleViewH)
            $0.left.right.equalToSuperview().offset(0)
            $0.height.equalTo(0.5)
        }

        view.addSubview(lineView2)
        lineView2.snp.makeConstraints {
            $0.top.equalTo(switchLabel.snp.bottom).offset(20.fitSizeFrom750)
            $0.left.right.equalToSuperview().offset(0)
            $0.height.equalTo(0.5)
        }

        view.addSubview(showNetFlowDetailBtn)
        showNetFlowDetailBtn.snp.makeConstraints {
            $0.top.equalTo(switchLabel.snp.bottom).offset(50.fitSizeFrom750)
            $0.left.equalToSuperview().offset(15.fitSizeFrom750)
            $0.right.equalToSuperview().offset(-15.fitSizeFrom750)
            $0.height.equalTo(50.fitSizeFrom750)
        }
    }

    @objc
    func switchAction(_ sender: UISwitch) {
        AssistantCacheManager.shared.saveNetFlowSwitch(sender.isOn)
        if sender.isOn {
            NetFlowManager.shared.canInterceptNetFlow(true)
            showOscillogramView()
        } else {
            NetFlowManager.shared.canInterceptNetFlow(false)
            hiddenOscillogramView()
        }
    }

    func showOscillogramView() {
        AssistantNetFlowOscillogramWindow.shared.show()
    }

    func hiddenOscillogramView() {
        AssistantNetFlowOscillogramWindow.shared.hide()
    }

    // swiftlint:disable line_length
    @objc
    func detailBtnAction(_ sender: UIButton) {

        let vc1 = NetFlowSummaryViewController()
        let nav1 = AssistantNavigationController(rootViewController: vc1)
        nav1.delegate = self
        nav1.interactivePopGestureRecognizer?.delegate = self
        nav1.tabBarItem = UITabBarItem(title: "网络监控摘要", image: UIImage.assistant_xcassetImageNamed(name: "doraemon_netflow_summary_unselect")?.assistantResize(CGSize(width: 30, height: 30)).withRenderingMode(.alwaysOriginal), selectedImage: UIImage.assistant_xcassetImageNamed(name: "doraemon_netflow_summary_select")?.assistantResize(CGSize(width: 30, height: 30)).withRenderingMode(.alwaysOriginal))
        nav1.tabBarItem.setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor.white, NSAttributedString.Key.font: UIFont.regular(10) ?? UIFont.systemFont(ofSize: 10)], for: UIControl.State.normal)
        nav1.tabBarItem.setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor.assistant_colorWithHex(0x337CC4), NSAttributedString.Key.font: UIFont.regular(10) ?? UIFont.systemFont(ofSize: 10)], for: UIControl.State.selected)

        let vc2: UIViewController = NetFlowListViewController()
        let nav2: UINavigationController = AssistantNavigationController(rootViewController: vc2)
        nav2.delegate = self
        nav2.interactivePopGestureRecognizer?.delegate = self
        nav2.tabBarItem = UITabBarItem(title: "网络监控列表", image: UIImage.assistant_xcassetImageNamed(name: "doraemon_netflow_list_unselect")?.assistantResize(CGSize(width: 30, height: 30)).withRenderingMode(.alwaysOriginal), selectedImage: UIImage.assistant_xcassetImageNamed(name: "doraemon_netflow_list_select")?.assistantResize(CGSize(width: 30, height: 30)).withRenderingMode(.alwaysOriginal))
        nav2.tabBarItem.setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor.white, NSAttributedString.Key.font: UIFont.regular(10) ?? UIFont.systemFont(ofSize: 10)], for: UIControl.State.normal)
        nav2.tabBarItem.setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor.assistant_colorWithHex(0x337CC4), NSAttributedString.Key.font: UIFont.regular(10) ?? UIFont.systemFont(ofSize: 10)], for: UIControl.State.selected)

        tabBar.viewControllers = [nav1, nav2]
        tabBar.modalPresentationStyle = .fullScreen
        tabBar.tabBar.backgroundImage = navBgImage
        self.present(tabBar, animated: true, completion: nil)
    }
}

extension NetFlowViewController: UINavigationControllerDelegate, UIGestureRecognizerDelegate {

    func navigationController(_ navigationController: UINavigationController, didShow viewController: UIViewController, animated: Bool) {
        if navigationController.responds(to: #selector(getter: UINavigationController.interactivePopGestureRecognizer)) {
            if navigationController.viewControllers.count > 1 {
                // swiftlint:disable line_length
                navigationController.interactivePopGestureRecognizer?.isEnabled = (viewController.disablePopGestureRecognizer == nil) ? true : !(viewController.disablePopGestureRecognizer ?? false)
            } else {
                navigationController.interactivePopGestureRecognizer?.isEnabled = false
            }
        }
    }

}
