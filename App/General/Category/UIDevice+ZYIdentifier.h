//
//  UIDevice+ZYIdentifier.h
//  Feel
//
//  Created by BB9z on 6/20/16.
//  Copyright © 2016 Beijing ZhiYun ZhiYuan Technology Co., Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIDevice (ZYIdentifier)

/// telephony radio access technology
+ (nullable NSString *)ZYAccessTechnology;

/// wifi, 2G, 3G, 4G, unknow, 其它未识别的按原样显示
+ (nullable NSString *)ZYReadableNetworkAccessTechnology;

@end
