/*
 NSDate+App

 Copyright © 2018 RFUI.
 Copyright © 2016 Beijing ZhiYun ZhiYuan Technology Co., Ltd.
 https://github.com/BB9z/iOS-Project-Template
 
 Apache License, Version 2.0
 http://www.apache.org/licenses/LICENSE-2.0
 */

#import <MBGeneralType.h>

/// 判断一个时间是否在最近给定的范围内
extern BOOL NSDateIsRecent(NSDate *_Nullable date, NSTimeInterval range);

@interface NSDate (App)

/**
 允许在 Swift 创建 NSMilliDate
 */
@property (nonnull, readonly) NSMilliDate *milliDate;

/**
 Swift 中转换
 */
@property (nonnull, readonly) NSDate *NSDate;

@end
