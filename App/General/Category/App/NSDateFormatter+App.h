/*
 NSDateFormatter+App

 Copyright © 2018 RFUI.
 Copyright © 2016 Beijing ZhiYun ZhiYuan Technology Co., Ltd.
 https://github.com/BB9z/iOS-Project-Template
 
 Apache License, Version 2.0
 http://www.apache.org/licenses/LICENSE-2.0
 */

#import "UIKit+App.h"

@interface NSDateFormatter (App)

/// MBDateDayIdentifier 专用格式化
+ (nonnull NSDateFormatter *)cachedDayIdentifierFormatter;

/// 本地化的 X年X月X日
+ (nonnull NSDateFormatter *)cachedYMDDateFormatter;

/// 本地化的 X月X日
+ (nonnull NSDateFormatter *)cachedMDDateFormatter;

/// 本地化的周几
+ (nonnull NSDateFormatter *)cachedShortWeekDayFormatter;

@end
