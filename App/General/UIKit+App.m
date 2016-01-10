
#import "UIKit+App.h"
#import "RFDrawImage.h"

UIStoryboard *MainStoryboard;
int const UIColorGlobalTintColorHex = 0xFF0000;

@implementation UIColor (App)

+ (UIColor *)globalTintColor {
    static UIColor *sharedInstance = nil;
    static dispatch_once_t oncePredicate;
    dispatch_once(&oncePredicate, ^{
        sharedInstance = [UIColor colorWithRGBHex:UIColorGlobalTintColorHex alpha:1];
    });
	return sharedInstance;
}

+ (UIColor *)globalHighlightedTintColor {
    static UIColor *sharedInstance = nil;
    static dispatch_once_t oncePredicate;
    dispatch_once(&oncePredicate, ^{
        sharedInstance = [[self globalTintColor] mixedColorWithRatio:.25 color:[UIColor colorWithRGBHex:0xFFFFFF]];
    });
	return sharedInstance;
}

+ (UIColor *)globalDisabledTintColor {
    static UIColor *sharedInstance = nil;
    static dispatch_once_t oncePredicate;
    dispatch_once(&oncePredicate, ^{
        sharedInstance = [UIColor colorWithRGBHex:0xCCCCCC alpha:1];
    });
	return sharedInstance;
}

+ (UIColor *)globalPlaceholderTextColor {
    static UIColor *sharedInstance = nil;
    static dispatch_once_t oncePredicate;
    dispatch_once(&oncePredicate, ^{
        sharedInstance = [UIColor colorWithRGBHex:0x898989 alpha:1];
    });
	return sharedInstance;
}

+ (UIColor *)globalTextColor {
    static UIColor *sharedInstance = nil;
    static dispatch_once_t oncePredicate;
    dispatch_once(&oncePredicate, ^{
        sharedInstance = [UIColor colorWithRGBHex:0x222222 alpha:1];
    });
	return sharedInstance;
}

@end


@implementation UIImage (App)


@end

@implementation NSString (App)

- (BOOL)isValidEmail {
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:self];
}

- (BOOL)isValidPhoneNumber {
	NSString * MOBILE = @"^1\\d{10}$";
	NSPredicate *regextestmobile = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", MOBILE];
    return [regextestmobile evaluateWithObject:self];
}

@end


@implementation UIButton (App)

- (NSString *)text {
    return self.currentTitle;
}

- (void)setText:(NSString *)text {
    [self setTitle:text forState:UIControlStateNormal];
}

@end


@implementation UITextField (App)

- (NSString *)trimedText {
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


@implementation UICollectionView (App)

- (void)deselectItemsAnimated:(BOOL)animated {
    NSArray *items = [self indexPathsForSelectedItems];
    if (!items.count) return;

    for (NSIndexPath *ip in items) {
        [self deselectItemAtIndexPath:ip animated:animated];
    }
}

@end


#import "MBEntityExchanging.h"

@implementation UITableViewCell (App)

+ (id)itemFromSender:(id)sender {
    id<MBEntityExchanging> cell = (id)[sender superviewOfClass:[self class]];
    if (![cell respondsToSelector:@selector(item)]) {
        return nil;
    }
    return [cell item];
}

@end


@implementation UICollectionViewCell (App)

+ (id)itemFromSender:(id)sender {
    id<MBEntityExchanging> cell = (id)[sender superviewOfClass:[self class]];
    if (![cell respondsToSelector:@selector(item)]) {
        return nil;
    }
    return [cell item];
}

@end


@implementation UIViewController (App)

+ (instancetype)newFromStoryboard {
    UIStoryboard *sb = self.storyboardName? [UIStoryboard storyboardWithName:self.storyboardName bundle:nil] : MainStoryboard;
    @try {
        return [sb instantiateViewControllerWithIdentifierUsingClass:[self class]];
    }
    @catch (NSException *exception) {
        dout_error(@"Cannot find %@ in %@ storyboard", self, self.storyboardName?: @"Main");
    }
}

+ (NSString *)storyboardName {
    return nil;
}

@end

