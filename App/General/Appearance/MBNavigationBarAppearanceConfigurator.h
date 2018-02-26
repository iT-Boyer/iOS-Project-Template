/*!
    MBNavigationBarAppearanceConfigurator
    v 2.0

    Copyright © 2014 Chinamobo Co., Ltd.
    https://github.com/Chinamobo/iOS-Project-Template

    Apache License, Version 2.0
    http://www.apache.org/licenses/LICENSE-2.0
 */
#import "MBAppearanceConfigurator.h"
#import "UIKit+App.h"
/**
 导航栏外观设置器
 
 如果你只想给特定对象设置样式，可以设置 appearance 和 barButtonItemAppearance

 示例：
 @code
 MBNavigationBarAppearanceConfigurator *nac = [MBNavigationBarAppearanceConfigurator new];
 nac.backgroundImage = [UIImage imageNamed:@"navigation_bar_background"];
 nac.barColor = [UIColor redColor];
 nac.itemTitleFontSize = 14;

 [nac applay];
 @endcode
 
 已知问题：
 - 用 backButtonIcon 设置返回按钮时，左侧的返回按钮标题仍会占据位置，建议重写导航设置每个 view controller 的返回按钮
 */
@interface MBNavigationBarAppearanceConfigurator : MBAppearanceConfigurator
@property (strong, nonatomic) id barButtonItemAppearance;

#pragma mark - 导航条

/// 导航条颜色
/// 默认白色
@property (strong, nonatomic) UIColor *barColor;

/// 背景图
@property (strong, nonatomic) UIImage *backgroundImage;

/// 移除背景图阴影
/// 默认 YES
@property (nonatomic) BOOL removeBarShadow;

#pragma mark - 标题
/// 标题颜色
/// 默认黑色
@property (strong, nonatomic) UIColor *titleColor;

/// 标题文字属性
@property (copy, nonatomic) NSDictionary *titleTextAttributes;

/// 要清空标题和按钮文字的阴影
/// 默认 YES
@property (nonatomic) BOOL clearTitleShadow;

#pragma mark - 按钮
/// 按钮颜色
/// 默认使用全局 tint color
@property (strong, nonatomic) UIColor *itemTitleColor;
@property (strong, nonatomic) UIColor *itemTitleHighlightedColor;
@property (strong, nonatomic) UIColor *itemTitleDisabledColor;

@property (nonatomic) CGFloat itemTitleFontSize;

/// 清空按钮背景
/// 默认 YES
@property (nonatomic) BOOL clearItemBackground;

/**
 返回按钮图像，建议尺寸高度为 22，并在右侧留有空白

 非空时，返回按钮将只显示这个图像，隐藏标题和箭头
 */
@property (strong, nonatomic) UIImage *backButtonIcon;
@end
