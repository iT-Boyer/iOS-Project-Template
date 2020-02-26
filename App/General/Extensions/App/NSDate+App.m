
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

@end
