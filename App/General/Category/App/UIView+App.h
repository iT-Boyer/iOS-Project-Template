/*!
 UIKit+App

 Copyright © 2018 RFUI.
 Copyright © 2016 Beijing ZhiYun ZhiYuan Technology Co., Ltd.
 https://github.com/BB9z/iOS-Project-Template

 Apache License, Version 2.0
 http://www.apache.org/licenses/LICENSE-2.0
 */
#import "UIKit+App.h"

@interface UIView (App)

/// 像素尺寸
- (CGSize)pixelSize;

- (BOOL)containsClassInResponderChain:(Class)aClass;

- (id)firstResponderOfClass:(Class)aClass;

@end
