/*!
    JSONValueTransformer (App)

    Copyright © 2014-2016 Beijing ZhiYun ZhiYuan Information Technology Co., Ltd.
    https://github.com/Chinamobo/iOS-Project-Template

    Apache License, Version 2.0
    http://www.apache.org/licenses/LICENSE-2.0
 */
#import "MBModel.h"
#import "NSDateFormatter+RFKit.h"
#import <MBGeneralType.h>

/**
 JSON Mode 的 ValueTransformer，用于将 JSON 类型转为其他类型
 
 通常用于时间转换
 */
@interface JSONValueTransformer (App)

@end

@implementation JSONValueTransformer (App)

- (NSDate *)NSDateFromNSNumber:(NSNumber *)string {
    NSTimeInterval time = [string floatValue];
    return [NSDate dateWithTimeIntervalSince1970:time];
}

- (NSDate *)NSDateFromNSString:(NSString*)string {
    NSTimeInterval time = [string floatValue];
    return [NSDate dateWithTimeIntervalSince1970:time];
}

- (NSString *)JSONObjectFromNSDate:(NSDate *)date {
    return [NSString stringWithFormat:@"%ld", (long)[date timeIntervalSince1970]];
}

- (NSDate *)NSMilliDateFromNSNumber:(NSNumber *)number {
    NSTimeInterval time = [number doubleValue]/1000;
    if (!time) return nil;
    return [NSDate dateWithTimeIntervalSince1970:time];
}

- (NSNumber *)JSONObjectFromNSMilliDate:(NSMilliDate *)date {
    return @([date timeIntervalSince1970] * 1000LL);
}

@end
