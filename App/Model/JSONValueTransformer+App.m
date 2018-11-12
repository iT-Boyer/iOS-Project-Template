/*
 JSONValueTransformer (App)
 
 Copyright © 2018 RFUI.
 Copyright © 2014-2016 Beijing ZhiYun ZhiYuan Information Technology Co., Ltd.
 https://github.com/BB9z/iOS-Project-Template
 
 Apache License, Version 2.0
 http://www.apache.org/licenses/LICENSE-2.0
 */
#import "MBModel.h"
#import <MBAppKit/MBGeneralType.h>

/**
 JSON Mode 的 ValueTransformer，用于将 JSON 类型转为其他类型
 
 通常用于时间转换
 */
@interface JSONValueTransformer (App)

@end

@implementation JSONValueTransformer (App)

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wobjc-protocol-method-implementation"

- (NSDate *)NSDateFromNSNumber:(NSNumber *)string {
    NSTimeInterval time = [string floatValue];
    return [NSDate dateWithTimeIntervalSince1970:time];
}
#pragma clang diagnostic pop

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
