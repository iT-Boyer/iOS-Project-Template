
#import "UIButton+App.h"
#import "RFBlockSelectorPerform.h"
@import ObjectiveC;


@implementation UIButton (App)

- (nullable NSString *)text {
    return self.currentTitle;
}

- (void)setText:(nullable NSString *)text {
    self.titleLabel.text = text;
    [self setTitle:text forState:UIControlStateNormal];
}

static char _category_inlineTapActionBlock;
- (void (^)(__kindof UIButton *))inlineTapActionBlock {
    return objc_getAssociatedObject(self, &_category_inlineTapActionBlock);
}

- (void)setInlineTapActionBlock:(void (^)(__kindof UIButton * _Nonnull))inlineTapActionBlock {
    void (^action)(id) = self.inlineTapActionBlock;
    if (action != inlineTapActionBlock) {
        if (action) {
            [self removeTarget:action action:@selector(rf_performBlockSelectorWithSender:) forControlEvents:UIControlEventTouchUpInside];
        }
        action = inlineTapActionBlock;
        objc_setAssociatedObject(self, &_category_inlineTapActionBlock, action, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        if (action) {
            [self addTarget:action action:@selector(rf_performBlockSelectorWithSender:) forControlEvents:UIControlEventTouchUpInside];
        }
    }
}

@end
