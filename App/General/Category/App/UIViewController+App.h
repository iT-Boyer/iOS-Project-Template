/*!
 UIKit+App

 Copyright © 2016 Beijing ZhiYun ZhiYuan Technology Co., Ltd. All rights reserved.
 https://github.com/zhiyun168/Feel-iOS
 */

#import "UIKit+App.h"

@interface UIViewController (App)

/**
 从 storyboard 创建当前 vc 实例
 */
+ (nonnull instancetype)newFromStoryboard;

/**
 定义视图在哪个 storyboard 中，newFromStoryboard 使用
 */
+ (nullable NSString *)storyboardName;

@end
