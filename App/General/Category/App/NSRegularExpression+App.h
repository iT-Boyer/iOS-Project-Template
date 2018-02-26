/*!
 UIKit+App

 Copyright © 2016 Beijing ZhiYun ZhiYuan Technology Co., Ltd. All rights reserved.
 https://github.com/zhiyun168/Feel-iOS
 */

#import "UIKit+App.h"

@interface NSRegularExpression (App)

/// @xxx 的正则
+ (nonnull NSRegularExpression *)globalMetionRegularExpression;

/// 中日韩字符 的正则
+ (nonnull NSRegularExpression *)CJKCharRegularExpression;

@end
