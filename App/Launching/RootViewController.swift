//
//  RootViewController.swift
//  App
//

/**
 应用顶层 vc

 嵌入主导航，这样如需遮盖导航的弹窗，可以加入到这里，比如启动闪屏、教程弹窗
 基类里做了对 vc 样式声明的铰接处理
 */
class RootViewController: MBRootViewController {

    override func awakeFromNib() {
        super.awakeFromNib()
        MBApp.status().rootViewController = self
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        let nav = NavigationController.newFromStoryboard()
        addChild(nav)
        if let navView = nav.view {
            navView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
            navView.frame = view.bounds
            view.insertSubview(navView, at: 0)
        }

        setupSplash()
    }

    // MARK: Splash

    private weak var splash: UIViewController?
    private func setupSplash() {
        let launchStoryboard = UIStoryboard(name: "LaunchScreen", bundle: nil)
        guard let vc = launchStoryboard.instantiateInitialViewController() else {
            fatalError()
        }
        addChildViewController(vc, into: view)
        splash = vc
        // 等 homeLoaded，最多等 3 秒
        AppEnv().waitFlags(.homeLoaded, do: {
            self.splashFinish()
        }, timeout: 3)
    }

    func splashFinish() {
        guard let vc = splash else { return }
        splash = nil
        UIView.animate(withDuration: 0.3, animations: {
            vc.view.alpha = 0
        }, completion: { _ in
            vc.removeFromParentViewControllerAndView()
            AppEnv().setFlagOn(.naigationLoaded)
        })
    }
}
