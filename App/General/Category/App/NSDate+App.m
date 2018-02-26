
#import "NSDate+App.h"

BOOL NSDateIsRecent(NSDate *_Nullable date, NSTimeInterval range) {
    if (!date) return NO;
    return fabs([[NSDate date] timeIntervalSinceDate:date]) <= range;
}

@implementation NSDate (App)

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
    return [[NSDateFormatter cachedHMDateFormatter] stringFromDate:self];
}

- (nonnull NSString *)timeString2 {
    if ([self isSameDayWithDate:[NSDate date]]) {
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

- (nonnull NSString *)dayStringWithoutYear {
    NSInteger dayDiff = [NSDate daysBetweenDate:[NSDate date] andDate:self];
    if (dayDiff <=2 && dayDiff >= -2) {
        NSString *key = [NSString stringWithFormat:@"NSDateDayOffsetName-%d", (int)dayDiff];
        return NSLocalizedString(key, "本地化日期");
    }
    return [[NSDateFormatter cachedMDDateFormatter] stringFromDate:self];
}

+ (ZYTimeStamp)timestampForNow {
    return [[NSDate date] timeIntervalSince1970] * 1000.f;
}

- (ZYTimeStamp)timestamp {
    return self.timeIntervalSince1970 * 1000.f;
}

+ (ZYDayIdentifier)dayIdentifierForToday {
    return [[NSDate date] dayIdentifier];
}

- (ZYDayIdentifier)dayIdentifier {
    return [[NSDateFormatter cachedDayIdentifierFormatter] stringFromDate:self];
}

+ (NSDate *)dateWithTimeStamp:(ZYTimeStamp)timestamp {
    return [NSDate dateWithTimeIntervalSince1970:timestamp / 1000];
}

+ (NSString *)durationMSSStringWithTimeStamp:(ZYTimeStamp)duration {
    return [NSString stringWithFormat:@"%02lld:%02lld.%02lld", duration/60000, (duration%60000)/1000, duration%1000/10];
}

+ (nonnull NSString *)durationMSStringWithTimeStamp:(ZYTimeStamp)duration {
    //平板支撑工具页时间四舍五入
    return [NSString stringWithFormat:@"%02d:%02d", (int)round((float)duration/1000)/60, (int)round((float)duration/1000)%60];
}

// Test Case: testLongDurationString
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

// Test Case: testMinuteDurationString
+ (nonnull NSString *)longMinuteStringWithTimeInterval:(NSTimeInterval)duration unitRang:(nullable NSRange *)rangeRef {
    NSString *numberPart = nil;
    NSString *unitPart = nil;
    if (duration < 1) {
        numberPart = @"0";
        unitPart = @" 分钟";
    }
    else if (duration < 60) {
        numberPart = @"1";
        unitPart = @" 分钟";
    }
    else if (duration < 9999.5 *60) {
        numberPart = [NSString stringWithFormat:@"%.0f", duration/60];
        unitPart = @" 分钟";
    }
    else if (duration < 999.95 *1000 *60) {
        numberPart = [NSString stringWithFormat:@"%.1fk", duration/60/1000];
        unitPart = @" 分钟";
    }
    else if (duration < 9999.5 *1000 *3600) {
        numberPart = [NSString stringWithFormat:@"%.0fk", duration/3600/1000];
        unitPart = @" 小时";
    }
    else {
        numberPart = [NSString stringWithFormat:@"%.0fk", duration/3600/24/1000];
        unitPart = @" 天";
    }
    if (rangeRef) {
        *rangeRef = NSMakeRange(numberPart.length, unitPart.length);
    }
    return [NSString stringWithFormat:@"%@%@", numberPart, unitPart];
}

- (long)dayIntervalSinceNow {
    return [self dayIntervalSinceDate:[NSDate date]];
}

- (long)dayIntervalSinceDate:(NSDate *)anotherDate {
    NSCalendar *cldr = [NSCalendar currentCalendar];
    NSDate *plainFromDate = nil;
    NSDate *plainToDate = nil;
    [cldr rangeOfUnit:NSCalendarUnitDay startDate:&plainFromDate interval:NULL forDate:anotherDate];
    [cldr rangeOfUnit:NSCalendarUnitDay startDate:&plainToDate interval:NULL forDate:self];
    NSDateComponents *comp = [cldr components:NSCalendarUnitDay fromDate:plainFromDate toDate:plainToDate options:NSCalendarWrapComponents];
    return comp.day;
}

+ (NSDate *)beginningOfCurrentWeek {
    NSDate *today = [NSDate date];
    NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    
    NSDateComponents *weekdayComponents = [gregorian components:NSWeekdayCalendarUnit fromDate:today];
    
    NSDateComponents *componentsToSubtract = [[NSDateComponents alloc] init];
    [componentsToSubtract setDay: 0 - ([weekdayComponents weekday] - 1)];
    
    NSDate *beginningOfWeek = [gregorian dateByAddingComponents:componentsToSubtract toDate:today options:0];
    
    NSDateComponents *components =
    [gregorian components:(NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit)
                 fromDate: beginningOfWeek];
    beginningOfWeek = [gregorian dateFromComponents:components];
    
    return beginningOfWeek;
}

@end
