/*!
 UIKit+App

 Copyright © 2016 Beijing ZhiYun ZhiYuan Technology Co., Ltd.
 https://github.com/BB9z/iOS-Project-Template
 
 Apache License, Version 2.0
 http://www.apache.org/licenses/LICENSE-2.0
 */

#import "UIKit+App.h"

@interface NSRegularExpression (App)

/// @xxx 的正则
+ (nonnull NSRegularExpression *)globalMetionRegularExpression;

/// 中日韩字符 的正则
+ (nonnull NSRegularExpression *)CJKCharRegularExpression;

@end
