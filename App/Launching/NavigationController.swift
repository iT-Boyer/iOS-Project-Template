//
//  NavigationController.swift
//  App
//
//  Created by BB9z on 2018/5/16.
//  Copyright © 2018 Chinamobo. All rights reserved.
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

        APUser.addCurrentUserChangeObserver(self, initial: false) { [weak self] user in
            if user != nil {
                self?.onLogin()
            }
            else {
                self?.onLogout()
            }
        }

        // @bug(iOS): 强制修改阴影
        let bar = navigationBar
        let shadow = RFLine(frame: CGRect(x: 0, y: bar.height - 1, width: bar.width, height: 1))
        shadow.isUserInteractionEnabled = false
        shadow.autoresizingMask = [ .flexibleTopMargin, .flexibleWidth ]
        shadow.backgroundColor = UIColor(rgbHex: 0xF3F3F3)
        shadow.isOpaque = true
        bar.addSubview(shadow)
        for v in bar.subviews.first?.subviews ?? [] {
            if v is UIImageView && v.height <= 1 {
                v.isHidden = true
            }
        }
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
