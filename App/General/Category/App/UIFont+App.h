/*
 UIFont+App

 Copyright © 2016 Beijing ZhiYun ZhiYuan Technology Co., Ltd.
 https://github.com/BB9z/iOS-Project-Template
 
 Apache License, Version 2.0
 http://www.apache.org/licenses/LICENSE-2.0
 */

#import "UIKit+App.h"

@interface UIFont (App)

+ (nonnull UIFont *)applicationFontOfSize:(CGFloat)fontSize;

/**
 全局内容字体
 */
+ (nonnull UIFont *)globalContentFont;

@end
