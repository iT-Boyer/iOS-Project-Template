/*!
 UIKit+App

 Copyright © 2016 Beijing ZhiYun ZhiYuan Technology Co., Ltd. All rights reserved.
 https://github.com/zhiyun168/Feel-iOS
 */

#import "UIKit+App.h"
#import <MBGeneralType.h>

/// 判断一个时间是否在最近给定的范围内
extern BOOL NSDateIsRecent(NSDate *_Nullable date, NSTimeInterval range);

@interface NSMilliDate (App)


@end

@interface NSDate (App)

/**
 允许在 Swift 创建 NSMilliDate
 */
@property (nonnull, readonly) NSMilliDate *milliDate;

/**
 Swift 中转换
 */
@property (nonnull, readonly) NSDate *NSDate;

/**
 刚刚、几分钟前、几小时前等样式
 */
- (nonnull NSString *)displayString;

/**
 今天，则“今天”
 今年，则本地化的 X月X日
 再久，本地化的X年X月X日
 */
- (nonnull NSString *)displayDateString;

/**
 最近几日范围：今天、明天、后天、昨天、前天
 其余，本地化的 X月X日
 */
- (nonnull NSString *)dayStringWithoutYear;

/**
 本地化的 hh:mm
 */
- (nonnull NSString *)timeString;

/**
 本地化的 hh:mm，非当日会带上月日
 */
- (nonnull NSString *)timeString2;

/// 当前时间的毫秒时间戳
+ (MBDateTimeStamp)timestampForNow;

/// 毫秒时间戳
- (MBDateTimeStamp)timestamp;

///
+ (nonnull MBDateDayIdentifier)dayIdentifierForToday;

- (nonnull MBDateDayIdentifier)dayIdentifier;

+ (nonnull NSDate *)dateWithTimeStamp:(MBDateTimeStamp)timestamp;

/// mm:ss 样式的时长
+ (nonnull NSString *)durationMSStringWithTimeStamp:(MBDateTimeStamp)duration;

/// 长时间的时长，根据长度单位自动切换为：分钟、小时、天、月、年
+ (nonnull NSString *)longDurationStringWithTimeInterval:(NSTimeInterval)duration unitRang:(nullable NSRange *)rangeRef;

/// 长时间的时长，根据长度单位自动切换为：分钟、小时、天
+ (nonnull NSString *)longMinuteStringWithTimeInterval:(NSTimeInterval)duration unitRang:(nullable NSRange *)rangeRef;

@end
