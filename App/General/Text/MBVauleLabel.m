
#import "MBVauleLabel.h"

@implementation MBVauleLabel

- (void)setValue:(id)value {
    _value = value;
    self.text = [self displayStringForVaule:value];
}

- (NSString *)displayStringForVaule:(id)value {
    if (self.vauleFormatBlock) {
        return self.vauleFormatBlock(self, value);
    }
    return [value description];
}

@end


@implementation MBVauleAttributedLabel
RFInitializingRootForUIView

- (void)onInit {

}

- (void)afterInit {
    // Nothing
}

- (void)awakeFromNib {
    [super awakeFromNib];
    self.attributedFormatString = self.attributedText;
}

- (void)setValue:(id)value {
    _value = value;

    BOOL isNull = !value;
    if (!isNull
        && self.treatZeroNumberAsNull
        && [value respondsToSelector:@selector(floatValue)]) {
        if ([value floatValue] == 0) {
            isNull = YES;
        }
    }

    if (isNull
        && self.nullValueDisplayString) {
        self.text = self.nullValueDisplayString;
        return;
    }
    self.attributedText = [self displayAttributedStringForVaule:value];
}

- (NSAttributedString *)displayAttributedStringForVaule:(id)value {
    if (self.vauleFormatBlock) {
        return self.vauleFormatBlock(self, value);
    }

    if (!self.attributedFormatString) return nil;

    NSString *formatString = [self.attributedFormatString string];
    NSRange strRange = NSMakeRange(0, formatString.length);

    NSTextCheckingResult *match = [[self.class floatFormatRegularExpression] firstMatchInString:formatString options:0 range:strRange];
    if (match) {
        NSString *valueFormat = [formatString substringWithRange:match.range];
        NSString *valueDisplayString = [NSString stringWithFormat:valueFormat, [value floatValue]];
        NSMutableAttributedString *as = [[NSMutableAttributedString alloc] initWithAttributedString:self.attributedFormatString];
        [as replaceCharactersInRange:match.range withString:valueDisplayString];
        return as;
    }

    match = [[self.class intFormatRegularExpression] firstMatchInString:formatString options:0 range:strRange];
    if (match) {
        NSString *valueFormat = [formatString substringWithRange:match.range];
        NSString *valueDisplayString = [NSString stringWithFormat:valueFormat, [value longValue]];
        NSMutableAttributedString *as = [[NSMutableAttributedString alloc] initWithAttributedString:self.attributedFormatString];
        [as replaceCharactersInRange:match.range withString:valueDisplayString];
        return as;
    }

    match = [[self.class objectFormatRegularExpression] firstMatchInString:formatString options:0 range:strRange];
    if (match) {
        NSString *valueFormat = [formatString substringWithRange:match.range];
        NSString *valueDisplayString = [NSString stringWithFormat:valueFormat, value];
        NSMutableAttributedString *as = [[NSMutableAttributedString alloc] initWithAttributedString:self.attributedFormatString];
        [as replaceCharactersInRange:match.range withString:valueDisplayString];
        return as;
    }
    return nil;
}

+ (NSRegularExpression *)floatFormatRegularExpression {
    static NSRegularExpression *sharedInstance = nil;
    static dispatch_once_t oncePredicate;
    dispatch_once(&oncePredicate, ^{
        sharedInstance = [NSRegularExpression regularExpressionWithPattern:@"%[0-9\\.]*[f]" options:NSRegularExpressionCaseInsensitive error:nil];
    });
    return sharedInstance;
}

+ (NSRegularExpression *)intFormatRegularExpression {
    static NSRegularExpression *sharedInstance = nil;
    static dispatch_once_t oncePredicate;
    dispatch_once(&oncePredicate, ^{
        sharedInstance = [NSRegularExpression regularExpressionWithPattern:@"%[#+-0-9\\.]*[idxXaAu]" options:NSRegularExpressionCaseInsensitive error:nil];
    });
    return sharedInstance;
}

+ (NSRegularExpression *)objectFormatRegularExpression {
    static NSRegularExpression *sharedInstance = nil;
    static dispatch_once_t oncePredicate;
    dispatch_once(&oncePredicate, ^{
        sharedInstance = [NSRegularExpression regularExpressionWithPattern:@"%@" options:NSRegularExpressionCaseInsensitive error:nil];
    });
    return sharedInstance;
}

@end


@implementation ZYDurationLabel

- (NSString *)displayStringForVaule:(id)value {
    RFAssert([value isKindOfClass:[NSNumber class]], nil);
    if (![value respondsToSelector:@selector(intValue)]) {
        return @"--:--:--";
    }
    int seconds = [value intValue];
    int minute = seconds/60;
    int hour = minute/60;
    minute = minute%60;
    seconds = seconds%60;

    NSString *ds;
    if (self.hourOptional && !hour) {
        ds = [NSString stringWithFormat:@"%02d:%02d", minute, seconds];
    }
    else {
        ds = [NSString stringWithFormat:@"%02d:%02d:%02d", hour, minute, seconds];
    }
    return ds;
}

@end


@implementation ZYDistanceLabel

- (NSAttributedString *)displayAttributedStringForVaule:(id)value {
    RFAssert([value isKindOfClass:[NSNumber class]], nil);
    if (![value respondsToSelector:@selector(doubleValue)]) {
        return nil;
    }

    double distance = [value doubleValue];
    NSString *numberString;
    NSString *unitString;
    if (distance < 1000 && self.autoUnit) {
        numberString = [NSString stringWithFormat:@"%d", (int)distance];
        unitString = @"m";
    }
    else {
        numberString = [NSString stringWithFormat:@"%.2f", distance/1000];
        unitString = @"km";
    }

    NSMutableAttributedString *string = [[NSMutableAttributedString alloc] initWithString:numberString attributes:self.numberAttributes];
    [string appendAttributedString:[[NSAttributedString alloc] initWithString:unitString attributes:self.unitAttributes]];
     return string;
}

@end
