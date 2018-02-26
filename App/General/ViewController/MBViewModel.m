
#import "MBViewModel.h"


@interface MBViewModel ()
@end

@implementation MBViewModel

- (instancetype)initWithViewController:(id)viewController {
    NSParameterAssert(viewController);
    self = super.init;
    if (self) {
        _viewController = viewController;
    }
    return self;
}

@end


void MBViewModelPropertySetterIMP(__kindof MBViewModel *self, id __strong *oldValue, id newValue, SEL noticeSelector) {
    if (self.disableNotice) {
        *oldValue = newValue;
        return;
    }
    if (MBObjectIsEquail(*oldValue, newValue)) return;
    id orgValue = *oldValue;
    *oldValue = newValue;

    id vc = self.viewController;
    if ([vc respondsToSelector:noticeSelector]) {
        void (*method)(id, SEL, id, id) = (void *)[vc methodForSelector:noticeSelector];
        method(vc, noticeSelector, orgValue, newValue);
    }
}
