/**
 ApplicationDelegate.swift
 
 Copyright © 2018 RFUI.
 https://github.com/BB9z/iOS-Project-Template
 
 Apache License, Version 2.0
 http://www.apache.org/licenses/LICENSE-2.0
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
        return true
    }
    
    func generalAppearanceSetup() {
        window.backgroundColor = .white
        window.tintColor = .globalTint
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
