/*
 NSNumber+App

 Copyright © 2018 RFUI.
 Copyright © 2016 Beijing ZhiYun ZhiYuan Technology Co., Ltd.
 https://github.com/BB9z/iOS-Project-Template
 
 Apache License, Version 2.0
 http://www.apache.org/licenses/LICENSE-2.0
 */

#import "UIKit+App.h"

@interface NSNumber (App)

/**
 将一个浮点数显示为价格字符串

 @code
 [NSNumber priceStringFromFloat:1.0199999 addPadding:YES];  // 1.02
 [NSNumber priceStringFromFloat:1.0 addPadding:YES];        // 1.00
 [NSNumber priceStringFromFloat:1.0 addPadding:NO];         // 1
 @endcode

 @param padding 是否补足小数点后两位
 */
+ (nonnull NSString *)priceStringFromFloat:(double)value addPadding:(BOOL)padding;

@end
