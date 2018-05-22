
#import "NSDate+App.h"

BOOL NSDateIsRecent(NSDate *_Nullable date, NSTimeInterval range) {
    if (!date) return NO;
    return fabs([NSDate.date timeIntervalSinceDate:date]) <= range;
}

@implementation NSDate (App)

- (NSMilliDate *)milliDate {
    return (NSMilliDate *)self;
}

- (NSDate *)NSDate {
    return (NSDate *)self;
}

- (BOOL)isSameYearWithDate:(NSDate *)date {
    if (!date) return false;

    NSDateComponents *target = [[NSCalendar currentCalendar] components:(NSCalendarUnit)(NSCalendarUnitYear) fromDate:date];
    NSDateComponents *source = [[NSCalendar currentCalendar] components:(NSCalendarUnit)(NSCalendarUnitYear) fromDate:self];
    return [target isEqual:source];
}

- (nonnull NSString *)displayString {
    NSTimeInterval diff = -[self timeIntervalSinceDate:[NSDate date]];
    if (diff < 3600*24) {
        if (diff < 60) {
            return @"刚刚";
        }
        int hour = diff/3600;
        if (hour < 1) {
            return [NSString stringWithFormat:@"%d分钟前", (int)diff/60];
        }
        return [NSString stringWithFormat:@"%d小时前", hour];
    }
    else if (diff < 3600*24*30) {
        NSInteger diffDays = [NSDate daysBetweenDate:self andDate:[NSDate date]];
        return [NSString stringWithFormat:@"%d天前", (int)diffDays];
    }

    return self.displayDateString;
}

- (nonnull NSString *)timeString {
    if ([self isSameDayWithDate:NSDate.date]) {
        return [[NSDateFormatter cachedHMDateFormatter] stringFromDate:self];
    }
    else {
        return [[NSDateFormatter cachedMDHMDateFormatter] stringFromDate:self];
    }
}

- (nonnull NSString *)displayDateString {
    if ([self isSameDayWithDate:[NSDate date]]) {
        return @"今天";
    }
    else if ([self isSameYearWithDate:[NSDate date]]) {
        return [[NSDateFormatter cachedMDDateFormatter] stringFromDate:self];
    }
    else {
        return [[NSDateFormatter cachedYMDDateFormatter] stringFromDate:self];
    }
}

+ (MBDateTimeStamp)timestampForNow {
    return [[NSDate date] timeIntervalSince1970] * 1000.f;
}

- (MBDateTimeStamp)timestamp {
    return self.timeIntervalSince1970 * 1000.f;
}

- (MBDateDayIdentifier)dayIdentifier {
    return [[NSDateFormatter cachedDayIdentifierFormatter] stringFromDate:self];
}

+ (nonnull NSString *)durationMSStringWithTimeStamp:(MBDateTimeStamp)duration {
    //平板支撑工具页时间四舍五入
    return [NSString stringWithFormat:@"%02d:%02d", (int)round((float)duration/1000)/60, (int)round((float)duration/1000)%60];
}

+ (nonnull NSString *)longDurationStringWithTimeInterval:(NSTimeInterval)duration unitRang:(nullable NSRange *)rangeRef {
    NSString *numberPart = nil;
    NSString *unitPart = nil;
    if (duration < 1) {
        numberPart = @"0";
        unitPart = @"";
    }
    if (duration < 999.95 *60) {
        numberPart = [NSString stringWithFormat:@"%.1f", duration/60];
        unitPart = @" 分钟";
    }
    else if (duration < 10000 *60) {
        numberPart = [NSString stringWithFormat:@"%.0f", duration/60];
        unitPart = @" 分钟";
    }
    else if (duration < 999.95 *3600) {
        numberPart = [NSString stringWithFormat:@"%.1f", duration/3600];
        unitPart = @" 小时";
    }
    else if (duration < 9999.5 *3600) {
        numberPart = [NSString stringWithFormat:@"%.0f", duration/3600];
        unitPart = @" 小时";
    }
    else if (duration < 999.95 *86400) {
        numberPart = [NSString stringWithFormat:@"%.1f", duration/3600/24];
        unitPart = @" 天";
    }
    else if (duration < 10000 *86400) {
        numberPart = [NSString stringWithFormat:@"%.0f", duration/3600/24];
        unitPart = @" 天";
    }
    else {
        numberPart = [NSString stringWithFormat:@"%.1f", duration/3600/24/30];
        unitPart = @" 月";
    }
    if (rangeRef) {
        *rangeRef = NSMakeRange(numberPart.length, unitPart.length);
    }
    return [NSString stringWithFormat:@"%@%@", numberPart, unitPart];
}

@end
