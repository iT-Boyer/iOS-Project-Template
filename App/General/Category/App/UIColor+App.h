/*!
 UIKit+App

 Copyright © 2016 Beijing ZhiYun ZhiYuan Technology Co., Ltd.
 https://github.com/BB9z/iOS-Project-Template
 
 Apache License, Version 2.0
 http://www.apache.org/licenses/LICENSE-2.0
 */

#import "UIKit+App.h"

@interface UIColor (App)

/// 占位符文本颜色
@property (class, nonnull, readonly) UIColor *globalPlaceholderTextColor;

#pragma mark -

/// 比当前颜色浅一些的颜色
- (nonnull UIColor *)rf_lighterColor;

/// 比当前颜色深一些的颜色
- (nonnull UIColor *)rf_darkerColor;

@end
