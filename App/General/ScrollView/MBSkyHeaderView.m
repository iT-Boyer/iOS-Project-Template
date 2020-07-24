
#import "MBSkyHeaderView.h"

@interface MBSkyHeaderView ()
@end

@implementation MBSkyHeaderView

- (void)onInit {
    [super onInit];
    self.scrollEnabled = NO;
}

- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event {
    UIView *v = [super hitTest:point withEvent:event];
    if ([v isKindOfClass:[UIControl class]]) {
        return v;
    }
    return nil;
}

@end
