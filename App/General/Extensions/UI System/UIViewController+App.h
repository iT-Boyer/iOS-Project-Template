/*
 UIViewController+App

 Copyright © 2018 RFUI.
 Copyright © 2016 Beijing ZhiYun ZhiYuan Technology Co., Ltd.
 https://github.com/BB9z/iOS-Project-Template
 
 The MIT License
 https://opensource.org/licenses/MIT
 */

#import "UIKit+App.h"

@interface UIViewController (App)

// @MBDependency:4
/**
 从 storyboard 创建当前 vc 实例

 Stroyboard ID 需要与类名一致，类里必须通过 storyboardName 指定 storyboard 文件的文件名
 */
+ (nonnull instancetype)newFromStoryboard;

// @MBDependency:4
/**
 定义视图在哪个 storyboard 中，newFromStoryboard 使用
 */
+ (nullable NSString *)storyboardName;

// @MBDependency:4
/**
 安全的 presentViewController，仅当当前 vc 是导航中可见的 vc 时才 present
 
 @param completion presented 参数代表给定 vc 是否被弹出
 */
- (void)RFPresentViewController:(nonnull UIViewController *)viewControllerToPresent animated:(BOOL)flag completion:(void (^ __nullable)(BOOL presented))completion;

@end
