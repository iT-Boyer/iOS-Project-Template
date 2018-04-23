/*!
 UIDevice+ZYIdentifier
 
 Copyright © 2018 RFUI.
 Copyright © 2016 Beijing ZhiYun ZhiYuan Technology Co., Ltd.
 https://github.com/BB9z/iOS-Project-Template
 
 Apache License, Version 2.0
 http://www.apache.org/licenses/LICENSE-2.0
 */

#import <UIKit/UIKit.h>

@interface UIDevice (ZYIdentifier)

/// telephony radio access technology
+ (nullable NSString *)ZYAccessTechnology;

/// wifi, 2G, 3G, 4G, unknow, 其它未识别的按原样显示
+ (nullable NSString *)ZYReadableNetworkAccessTechnology;

@end
