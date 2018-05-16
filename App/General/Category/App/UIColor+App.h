/*!
 UIKit+App

 Copyright © 2016 Beijing ZhiYun ZhiYuan Technology Co., Ltd.
 https://github.com/BB9z/iOS-Project-Template
 
 Apache License, Version 2.0
 http://www.apache.org/licenses/LICENSE-2.0
 */

#import "UIKit+App.h"

/// 全局颜色十六进制色值
extern int const UIColorGlobalTintColorHex;

@interface UIColor (App)

@property (class, nonnull, readonly) UIColor *globalTintColor;
@property (class, nonnull, readonly) UIColor *globalHighlightedTintColor;
@property (class, nonnull, readonly) UIColor *globalDisabledTintColor;

/// 标题颜色 #535353
@property (class, nonnull, readonly) UIColor *globalTitleTextColor;
/// 正文颜色 #5E6066
@property (class, nonnull, readonly) UIColor *globalBodyTextColor;
/// 描述文本颜色 #9B9B9B
@property (class, nonnull, readonly) UIColor *globalDetialTextColor;
/// 占位符文本颜色
@property (class, nonnull, readonly) UIColor *globalPlaceholderTextColor;

/// 最深的背景色 #222
@property (class, nonnull, readonly) UIColor *globalDarkBackgroundColor;
/// 最浅的背景色 #F5F5F5
@property (class, nonnull, readonly) UIColor *globalLightBackgroundColor;
/// 页面背景色全部变为 #F0F4F8
@property (class, nonnull, readonly) UIColor *globalPageBackgroundColor;
/// 默认 cell 点击时的高亮色
@property (class, nonnull, readonly) UIColor *globalCellSelectionColor;

/// 错误红 #800000
@property (class, nonnull, readonly) UIColor *globalErrorRead;

#pragma mark -

/// 比当前颜色浅一些的颜色
- (nonnull UIColor *)rf_lighterColor;

/// 比当前颜色深一些的颜色
- (nonnull UIColor *)rf_darkerColor;

@end
