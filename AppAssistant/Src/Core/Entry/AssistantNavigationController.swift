//
//  AssistantNavigationController.swift
//  Alamofire
//
//  Created by 王来 on 2020/10/14.
//

class AssistantNavigationController: UINavigationController {

    override init(rootViewController: UIViewController) {
        super.init(rootViewController: rootViewController)

        view.backgroundColor = .white
        navigationBar.isTranslucent = false
        navigationBar.setBackgroundImage(navBgImage, for: UIBarMetrics.default)

    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func pushViewController(_ viewController: UIViewController, animated: Bool) {

        if self.children.count >= 1 {
            viewController.hidesBottomBarWhenPushed = true
        }

        super.pushViewController(viewController, animated: animated)
    }

    override func popViewController(animated: Bool) -> UIViewController? {

        return super.popViewController(animated: animated)
    }

    func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        if children.count > 1 {
            return true
        } else {
            return false
        }
    }

}
