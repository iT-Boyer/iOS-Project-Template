
#import "UILabel+App.h"
#import "debug.h"

@implementation UILabel (App)

- (void)setAttributedTextWithValueText:(NSString *)valueText unitRange:(NSRange)unitRang unitFont:(UIFont *)unitFont {
    if (!valueText) return;
    UIFont *defaultFont = [self.font fontWithSize:self.RFSuggestFontSizeAccordingToLabelHight];
    if (!defaultFont) {
        DebugLog(YES, nil, @"Cannot get font from label");
        return;
    }
    NSMutableAttributedString *as = [[NSMutableAttributedString alloc] initWithString:valueText attributes:@{ NSFontAttributeName : defaultFont }];
    if (unitRang.length
        && unitFont) {
        [as setAttributes:@{ NSFontAttributeName : unitFont } range:unitRang];
    }
    self.attributedText = as;
}

@end
