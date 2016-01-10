/*!
    UIKit+App

    Copyright © 2014-2016 Beijing ZhiYun ZhiYuan Information Technology Co., Ltd.
    Copyright © 2014 Chinamobo Co., Ltd.
    https://github.com/Chinamobo/iOS-Project-Template

    Apache License, Version 2.0
    http://www.apache.org/licenses/LICENSE-2.0

    全局资源共享

    把可重复利用的资源放在这里
 */
#import <UIKit/UIKit.h>
#import "UITableView+RFTableViewCellHeight.h"

/**
 Storyboard 全局变量
 */
extern UIStoryboard *MainStoryboard;

@interface UIColor (App)

+ (UIColor *)globalTintColor;
+ (UIColor *)globalHighlightedTintColor;
+ (UIColor *)globalDisabledTintColor;

/// 占位符文本颜色
+ (UIColor *)globalPlaceholderTextColor;

+ (UIColor *)globalTextColor;

@end

@interface UIImage (App)

@end

@interface NSString (App)

/// email 格式检查
- (BOOL)isValidEmail;

/// 是否是大陆手机手机号
- (BOOL)isValidPhoneNumber;
@end


@interface UIButton (App)
/// 当前标题
- (NSString *)text;

/// 设置 normal 状态的标题
- (void)setText:(NSString *)text;
@end


@interface UITextField (App)
- (NSString *)trimedText;
- (NSRange)selectedRange;

@end

@interface UICollectionView (App)

- (void)deselectItemsAnimated:(BOOL)animated;

@end

@interface UITableViewCell (App)

+ (id)itemFromSender:(id)sender;

@end

@interface UICollectionViewCell (App)

+ (id)itemFromSender:(id)sender;

@end


@interface UIViewController (App)

/**
 从 storyboard 创建当前 vc 实例
 */
+ (instancetype)newFromStoryboard;

/**
 定义视图在哪个 storyboard 中，newFromStoryboard 使用
 */
+ (NSString *)storyboardName;

@end

#pragma mark - 导航/状态栏显隐

/// 浅色风格的状态栏
#define MBPreferredLightContentStatusBar \
- (UIStatusBarStyle)preferredStatusBarStyle { return UIStatusBarStyleLightContent; }

// 默认风格的状态栏
#define MBPreftrredDefaultContentStatusBar \
- (UIStatusBarStyle)preferredStatusBarStyle { return UIStatusBarStyleDefault; }

/// 不显示状态栏
#define MBPrefersStatusBarHidden \
- (BOOL)prefersStatusBarHidden { return YES; }

/// 隐藏导航栏
#define MBPrefersNavigationBarHidden \
- (BOOL)prefersNavigationBarHidden { return YES; }

/// 显示底部 bar
#define MBPrefersBottomBarShown \
- (BOOL)prefersBottomBarShown { return YES; }

