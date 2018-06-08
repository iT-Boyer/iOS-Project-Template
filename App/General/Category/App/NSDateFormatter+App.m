
#import "NSDateFormatter+App.h"

@implementation NSDateFormatter (App)

+ (NSDateFormatter *)cachedDayIdentifierFormatter {
    static NSDateFormatter *df = nil;
    if (!df) {
        df = NSDateFormatter.new;
        df.locale = NSLocale.currentLocale;
        df.dateFormat = @"yyyyMMdd";
    }
    return df;
}

+ (NSDateFormatter *)cachedYMDDateFormatter {
    static NSDateFormatter *df = nil;
    if (!df) {
        df = [NSDateFormatter currentLocaleFormatterFromTemplate:@"yMMMMd"];
    }
    return df;
}

+ (NSDateFormatter *)cachedMDDateFormatter {
    static NSDateFormatter *df = nil;
    if (!df) {
        df = [NSDateFormatter currentLocaleFormatterFromTemplate:@"MMMMd"];
    }
    return df;
}

+ (NSDateFormatter *)cachedHMDateFormatter {
    static NSDateFormatter *df = nil;
    if (!df) {
        df = [NSDateFormatter currentLocaleFormatterFromTemplate:@"hh:mm"];
    }
    return df;
}

+ (NSDateFormatter *)cachedShortWeekDayFormatter {
    static NSDateFormatter *df = nil;
    if (!df) {
        df = [NSDateFormatter currentLocaleFormatterFromTemplate:@"EEEEE"];
    }
    return df;
}

@end
