//
//  NavigationController.swift
//  App
//
//  Created by BB9z on 2018/5/16.
//  Copyright © 2018 RFUI.
//

/**
 应用主导航控制器
 */
class NavigationController: MBNavigationController {
    override class func storyboardName() -> String {
        return "Main"
    }
    
    override func onInit() {
        super.onInit()
        MBApp.status().globalNavigationController = self
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // 强制设置一些初始状态，否则会有异常
        defaultAppearanceAttributes[.prefersBottomBarShownAttribute] = 0
        bottomBarHidden = true
        AppAPI()

        Account.addCurrentUserChangeObserver(self, initial: false) { [weak self] user in
            if user != nil {
                self?.onLogin()
            }
            else {
                self?.onLogout()
            }
        }
        hideShadow()
    }

    /// 隐藏导航阴影
    func hideShadow() {
        navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationBar.shadowImage = UIImage()
    }
    
    func onLogout() {
        // todo
    }
    
    func onLogin() {
        // todo
    }
    
    override func presentLoginScene() {
        // todo
    }
    
    override func navigationController(_ navigationController: UINavigationController, didShow viewController: UIViewController, animated: Bool) {
        super.navigationController(navigationController, didShow: viewController, animated: animated)
        
        if viewController.rfPrefersDisabledInteractivePopGesture {
            // 禁用返回手势，只禁用就行，会自行恢复
            interactivePopGestureRecognizer?.isEnabled = false
        }
    }
}

// MARK: - Jump
extension NavigationController {
    @IBAction func navigationBackToHome(_ sender: Any?) {
        popToRootViewController(animated: true)
    }
}

// MARK: -

extension UINavigationController {
    func remove(_ vc: UIViewController?, animated: Bool) {
        guard let vc = vc, viewControllers.contains(vc) else {
            return
        }
        if vc == topViewController {
            popViewController(animated: animated)
            return
        }
        var vcs = viewControllers
        if let idx = vcs.index(of: vc) {
            vcs.remove(at: idx)
            setViewControllers(vcs, animated: true)
        }
    }
}
