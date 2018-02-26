/*!
 UIKit+App

 Copyright © 2016 Beijing ZhiYun ZhiYuan Technology Co., Ltd. All rights reserved.
 https://github.com/zhiyun168/Feel-iOS
 */

#import "UIKit+App.h"

#define FromViewContains(View, CLASS) ([View containsClassInResponderChain:[CLASS class]])

@interface UIView (App)

/// 像素尺寸
- (CGSize)pixelSize;

- (BOOL)containsClassInResponderChain:(Class)aClass;

- (id)firstResponderOfClass:(Class)aClass;

+ (instancetype)loadFromNib;

@end
