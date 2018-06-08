
#import "NSDate+App.h"
#import "NSDateFormatter+App.h"

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
    if (!date) return NO;

    NSDateComponents *target = [[NSCalendar currentCalendar] components:(NSCalendarUnit)(NSCalendarUnitYear) fromDate:date];
    NSDateComponents *source = [[NSCalendar currentCalendar] components:(NSCalendarUnit)(NSCalendarUnitYear) fromDate:self];
    return [target isEqual:source];
}

- (nonnull NSString *)recentString {
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

+ (NSDate *)dateWithTimeStamp:(MBDateTimeStamp)timestamp {
    return [NSDate dateWithTimeIntervalSince1970:timestamp / 1000];
}

@end
