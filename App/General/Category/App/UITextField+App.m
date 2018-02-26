
#import "UITextField+App.h"

@implementation UITextField (App)

- (nonnull NSString *)trimedText {
    return [self.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
}

//! REF: http://stackoverflow.com/a/11354330/945906
- (NSRange)selectedRange MB_SHOULD_MERGE_INTO_LIB {
    UITextRange *selectedTextRange = self.selectedTextRange;
    NSUInteger location = [self offsetFromPosition:self.beginningOfDocument toPosition:selectedTextRange.start];
    NSUInteger length = [self offsetFromPosition:selectedTextRange.start toPosition:selectedTextRange.end];
    return NSMakeRange(location, length);
}

@end
