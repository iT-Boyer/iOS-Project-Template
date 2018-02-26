/*!
 UIKit+App

 Copyright © 2016 Beijing ZhiYun ZhiYuan Technology Co., Ltd. All rights reserved.
 https://github.com/zhiyun168/Feel-iOS
 */

#import "UIKit+App.h"

@interface NSNumber (App)

/**
 大数时显示 x.x k，x.x 万，x.x 百万
 */
- (nonnull NSString *)displayString;

/**
 跟 displayString 表现一致，带单位
 */
- (nonnull NSString *)displayStringWithUnitRange:(nullable NSRange *)rangRef;

+ (nonnull NSString *)stringFromInt:(int)value;

/// 为 0 显示 --，正常显示 x.x
+ (nonnull NSString *)stringFromFloat:(double)value;

+ (nonnull NSString *)stringFromIntNumber:(nullable NSNumber *)value;
+ (nonnull NSString *)stringFromFloatNumber:(nullable NSNumber *)value;

/**
 将一个浮点数显示为字符串

 @code
 [NSNumber priceStringFromFloat:1.0199999 addPadding:YES];  // 1.02
 [NSNumber priceStringFromFloat:1.0 addPadding:YES];        // 1.00
 [NSNumber priceStringFromFloat:1.0 addPadding:NO];         // 1
 @endcode

 @param padding 是否补足小数点后两位
 */
+ (nonnull NSString *)priceStringFromFloat:(double)value addPadding:(BOOL)padding;

@end
