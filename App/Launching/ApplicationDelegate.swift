//
//  ApplicationDelegate.swift
//  App
//

/**
 注意是基于 MBApplicationDelegate 的，大部分 UIApplicationDelegate 方法需要调用 super

 外部推荐尽可能通过 addAppEventListener() 来监听事件；
 MBApplicationDelegate 默认未分发的方法可以自定义，通过 enumerateEventListeners() 方法进行分发。
 */
@UIApplicationMain
class ApplicationDelegate: MBApplicationDelegate {
    override func application(_ application: UIApplication, willFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]? = nil) -> Bool {
        AppUserDefaultsShared().applicationLastLaunchTime = Date()
        _ = MBApp.status()
        return true
    }

    override func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]? = nil) -> Bool {
        #if PREVIEW
        #elseif DEBUG
        // https://github.com/BB9z/iOS-Project-Template/wiki/%E6%8A%80%E6%9C%AF%E9%80%89%E5%9E%8B#tools-implement-faster
        Bundle(path: "/Applications/InjectionIII.app/Contents/Resources/iOSInjection.bundle")?.load()
        #endif
        Account.setup()
//        MBEnvironment.registerWorkers()
        RFKeyboard.autoDisimssKeyboardWhenTouch = true
        setupUIAppearance()
        dispatch_after_seconds(0) {
            MBDebugWindowButton.installToKeyWindow()
        }
        return true
    }

    func setupUIAppearance() {
        // 统一全局色，storyboard 的全局色只对部分 UI 生效，比如无法对 UIAlertController 应用
        window.tintColor = UIColor(named: "primary")!

        // 列表 data source 全局调整
        MBListDataSource<AnyObject>.defualtPageStartZero = false
        MBListDataSource<AnyObject>.defaultPageSizeParameterName = "size"
        MBListDataSource<AnyObject>.defaultFetchFailureHandler = { _, error in
            let e = error as NSError
            if e.domain == NSURLErrorDomain &&
                (e.code == NSURLErrorTimedOut
                || e.code == NSURLErrorNotConnectedToInternet) {
                // 超时断网不报错
            } else {
                AppHUD().alertError(e, title: nil, fallbackMessage: "列表加载失败")
            }
            return false
        }
    }

    override func applicationDidBecomeActive(_ application: UIApplication) {
        if !AppEnv().meetFlags(.appHasEnterForegroundOnce) {
            AppEnv().setFlagOn(.appHasEnterForegroundOnce)
            AppUserDefaultsShared().launchCount += 1
            AppUserDefaultsShared().launchCountCurrentVersion += 1
        }
        AppEnv().setFlagOn(.appInForeground)
        super.applicationDidBecomeActive(application)
    }

    override func applicationDidEnterBackground(_ application: UIApplication) {
        AppEnv().setFlagOff(.appInForeground)
        super.applicationDidEnterBackground(application)
    }

    override func application(_ application: UIApplication, continue userActivity: NSUserActivity, restorationHandler: @escaping ([UIUserActivityRestoring]?) -> Void) -> Bool {
        var hasHande = false
        enumerateEventListeners { listener in
            if listener.application?(application, continue: userActivity, restorationHandler: restorationHandler) ?? false {
                hasHande = true
            }
        }
        return hasHande
    }

    override func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey: Any] = [:]) -> Bool {
        if url.scheme == NavigationController.appScheme {
            NavigationController.jump(url: url, context: nil)
            return true
        }
        return super.application(app, open: url, options: options)
    }
}
