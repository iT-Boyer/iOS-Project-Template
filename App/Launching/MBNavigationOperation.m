
#import "MBNavigationOperation.h"
#import "MBNavigationController.h"


@implementation MBNavigationOperation
RFInitializingRootForNSObject

- (void)onInit {
}

- (void)afterInit {
}

- (NSString *)debugDescription {
    NSMutableString *des = [NSMutableString stringWithFormat:@"<%@: %p; ", self.class, (void *)self];
    NSString *subDes = self.subClassPropertyDescription;
    if (subDes) {
        [des appendString:subDes];
    }
    [des appendFormat:@"; %@ = %@; %@ = %@>",
     @keypath(self, animating), self.animating? @"YES" : @"NO",
     @keypath(self, topViewControllers), self.topViewControllers];
    return des;
}

+ (instancetype)operationWithConfiguration:(void (^)(__kindof MBNavigationOperation * _Nonnull))configBlock {
    MBNavigationOperation *ins = self.new;
    configBlock(ins);
    if (![ins validate]) {
        return nil;
    }
    return ins;
}

- (BOOL)validate {
    return YES;
}

- (NSString *)subClassPropertyDescription {
    return nil;
}

@end


@implementation ZYCustomTipNavigationOperation

- (void)onInit {
    [super onInit];
    _shouldDismissWhenViewControllerChange = YES;
    _canBlockOtherNonTipOperation = YES;
}

- (BOOL)validate {
    if (!super.validate) return NO;
    if (!self.block && !self.action) return NO;
    if (!self.dismissBlock) return NO;
    return YES;
}

@end

// 备忘
// complation 通知外部完成
// 显示后，主动点击、或被动取消（调 dismissBlock），都是成功的，这两处调 complation
// 因为不能弹出，从队列中移除时，调 complation 的 cancel
// 关于 tipOperationDisplaying 重置的位置，只需要在点击中就好了
@implementation ZYGestureHelpNavigationOperation

- (void)onInit {
    [super onInit];
    @weakify(self);
    self.dismissBlock = ^(id op, BOOL animated) {
        @strongify(self);
        [self.gestureHelpView removeFromSuperview];
        if (self.complation) {
            self.complation(NO);
            self.complation = nil;
        }
    };
}

- (BOOL)validate {
    if (!self.message || !self.prepare) return NO;
    return YES;
}

- (void)setDismissBlock:(void (^)(ZYCustomTipNavigationOperation * _Nonnull, BOOL))dismissBlock {
    if (self.dismissBlock) {
        RFAssert(false, @"不许外部设置");
        return;
    }
    [super setDismissBlock:dismissBlock];
}

- (void)setBlock:(dispatch_block_t)block {
    if (self.block) {
        RFAssert(false, @"不许外部设置");
        return;
    }
    [super setBlock:block];
}

@end


@implementation ZYAlertNavigationOperation

- (BOOL)validate {
    if (!super.validate) return NO;
    if (!self.alertController) return NO;
    return YES;
}

- (NSString *)subClassPropertyDescription {
    return [NSString stringWithFormat:@"alert = %@", self.alertController];
}

@end


@implementation ZYPresentNavigationOperation

- (BOOL)validate {
    if (!super.validate) return NO;
    if (!self.displayViewController) return NO;
    return YES;
}

- (NSString *)subClassPropertyDescription {
    return [NSString stringWithFormat:@"vc = %@", self.displayViewController];
}

@end
