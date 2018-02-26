/*!
 UIKit+App

 Copyright © 2016 Beijing ZhiYun ZhiYuan Technology Co., Ltd. All rights reserved.
 https://github.com/zhiyun168/Feel-iOS
 */

#import "UIKit+App.h"

@interface NSDateFormatter (App)

/// 服务器时间 yyyy-MM-dd
+ (nonnull NSDateFormatter *)serverDayFormatter;

/// ZYDayIdentifier 专用格式化
+ (nonnull NSDateFormatter *)cachedDayIdentifierFormatter;

/// 本地化的 X年X月X日
+ (nonnull NSDateFormatter *)cachedYMDDateFormatter;

/// 本地化的 X月X日
+ (nonnull NSDateFormatter *)cachedMDDateFormatter;

/// 本地化的 hh:mm
+ (nonnull NSDateFormatter *)cachedHMDateFormatter;

/// 本地化的 X月X日 hh:mm
+ (nonnull NSDateFormatter *)cachedMDHMDateFormatter;

/// 本地化的周几
+ (nonnull NSDateFormatter *)cachedShortWeekDayFormatter;

@end
