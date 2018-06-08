/**
 ApplicationDelegate.swift
 
 Copyright © 2018 RFUI.
 https://github.com/BB9z/iOS-Project-Template
 
 Apache License, Version 2.0
 http://www.apache.org/licenses/LICENSE-2.0
 */

/**
 注意是基于 MBApplicationDelegate 的，大部分 UIApplicationDelegate 方法需要调用 super，如果可能，外部推荐通过 addAppEventListener() 来监听事件。
 */
@UIApplicationMain
class ApplicationDelegate: MBApplicationDelegate {
    override func application(_ application: UIApplication, willFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey : Any]? = nil) -> Bool {
        AppUserDefaultsShared().applicationLastLaunchTime = Date()
        MBApp.status()
        return true
    }
    
    override func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey : Any]? = nil) -> Bool {
        APUser.setup()
        RFKeyboard.autoDisimssKeyboardWhenTouch = true
        setupUIAppearance()
        return true
    }
    
    func setupUIAppearance() {
        // 统一全局色，storyboard 的全局色只对部分 UI 生效，比如无法对 UIAlertController 应用
        window.tintColor = .globalTint
        MBListDataSource<AnyObject>.defaultFetchFailureHandler = { ds, error in
            let e = error as NSError
            if e.domain == NSURLErrorDomain &&
                (e.code == NSURLErrorTimedOut
                || e.code == NSURLErrorNotConnectedToInternet) {
                // 超时断网不报错
            }
            else {
                AppHUD().alertError(API.transformNSURLError(e) as NSError?, title: nil)
            }
            return false
        }
    }
    
    override func applicationDidBecomeActive(_ application: UIApplication) {
        AppEnv().setFlagOn(MBENV.flagAppInForeground.rawValue)
        AppEnv().setFlagOn(MBENV.flagAppHasEnterForegroundOnce.rawValue)
        super.applicationDidBecomeActive(application)
    }
    
    override func applicationDidEnterBackground(_ application: UIApplication) {
        AppEnv().setFlagOff(MBENV.flagAppInForeground.rawValue)
        super.applicationDidEnterBackground(application)
    }
}
