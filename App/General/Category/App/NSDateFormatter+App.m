
#import "NSDateFormatter+App.h"

@implementation NSDateFormatter (App)

+ (NSDateFormatter *)serverDayFormatter {
    static NSDateFormatter * share;
    if (!share) {
        share = [NSDateFormatter dateFormatterWithDateFormat:@"yyyy'-'MM'-'dd" timeZoneWithName:@"Asia/Hong_Kong"];
    }
    return [share copy];
}

+ (NSDateFormatter *)cachedDayIdentifierFormatter {
    static NSDateFormatter *df = nil;
    if (!df) {
        df = [[NSDateFormatter alloc] init];
        [df setLocale:[NSLocale currentLocale]];
        [df setDateFormat:@"yyyyMMdd"];
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

+ (NSDateFormatter *)cachedMDHMDateFormatter {
    static NSDateFormatter *df = nil;
    if (!df) {
        df = [NSDateFormatter currentLocaleFormatterFromTemplate:@"MMMMd hh:mm"];
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
