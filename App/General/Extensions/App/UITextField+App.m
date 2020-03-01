
#import "UITextField+App.h"

@implementation UITextField (App)

- (nullable NSString *)trimedText {
    return [self.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
}

//! REF: http://stackoverflow.com/a/11354330/945906
- (NSRange)selectedRange {
    UITextRange *selectedTextRange = self.selectedTextRange;
    NSUInteger location = [self offsetFromPosition:self.beginningOfDocument toPosition:selectedTextRange.start];
    NSUInteger length = [self offsetFromPosition:selectedTextRange.start toPosition:selectedTextRange.end];
    return NSMakeRange(location, length);
}

@end