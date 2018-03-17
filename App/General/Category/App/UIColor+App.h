/*!
 UIKit+App

 Copyright © 2016 Beijing ZhiYun ZhiYuan Technology Co., Ltd. All rights reserved.
 https://github.com/zhiyun168/Feel-iOS
 */

#import "UIKit+App.h"

/// 全局颜色十六进制色值
extern int const UIColorGlobalTintColorHex;

@interface UIColor (App)

+ (nonnull UIColor *)globalTintColor;
+ (nonnull UIColor *)globalHighlightedTintColor;
+ (nonnull UIColor *)globalDisabledTintColor;

/// 标题颜色 #535353
+ (nonnull UIColor *)globalTitleTextColor;
/// 正文颜色 #5E6066
+ (nonnull UIColor *)globalBodyTextColor;
/// 描述文本颜色 #9B9B9B
+ (nonnull UIColor *)globalDetialTextColor;
/// 占位符文本颜色
+ (nonnull UIColor *)globalPlaceholderTextColor;

/// 最深的背景色 #222
+ (nonnull UIColor *)globalDarkBackgroundColor;
/// 最浅的背景色 #F5F5F5
+ (nonnull UIColor *)globalLightBackgroundColor;
/// 页面背景色全部变为 #F0F4F8
+ (nonnull UIColor *)globalPageBackgroundColor;
/// 默认 cell 点击时的高亮色
+ (nonnull UIColor *)globalCellSelectionColor;

/// 错误红 #800000
+ (nonnull UIColor *)globalErrorRead;

#pragma mark -

/// 比当前颜色浅一些的颜色
- (nonnull UIColor *)rf_lighterColor;

/// 比当前颜色深一些的颜色
- (nonnull UIColor *)rf_darkerColor;

@end
