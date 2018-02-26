
#import "MBViewUpdateController.h"
@import ObjectiveC;

@interface MBViewUpdateController ()
@property (nonatomic) NSHashTable *_MBViewUpdateController_displayers;
@end

@implementation MBViewUpdateController

- (NSHashTable *)_MBViewUpdateController_displayers {
    if (!__MBViewUpdateController_displayers) {
        __MBViewUpdateController_displayers = [NSHashTable weakObjectsHashTable];
    }
    return __MBViewUpdateController_displayers;
}

- (void)addDisplayer:(id)displayer {
    [self._MBViewUpdateController_displayers addObject:displayer];
}

- (void)removeDisplayer:(id)displayer {
    [self._MBViewUpdateController_displayers removeObject:displayer];
}

MBSynthesizeSetNeedsMethodUsingAssociatedObject(setNeedsNoticeDelegateToUpdate, noticeDelegateToUpdate, .1)

- (void)noticeDelegateToUpdate {
    NSArray *all = [self._MBViewUpdateController_displayers allObjects];
    for (id<MBViewUpdateControllerDelegate> displayer in all) {
        if ([displayer respondsToSelector:@selector(updateUIWithUpdateController:)]) {
            [displayer updateUIWithUpdateController:self];
        }
    }
}

@end


@implementation MBViewUpdateController (MBIBOutletSupport)
@dynamic linkDisplayer;

- (void)setLinkDisplayer:(NSArray *)linkDisplayer {
    for (id obj in linkDisplayer) {
        [self addDisplayer:obj];
    }
}

@end
