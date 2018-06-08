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
        AppEnv().setFlagOn(MBENV.flagNaigationLoaded.rawValue)
    }
}
