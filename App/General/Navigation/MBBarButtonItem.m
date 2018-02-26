
#import "MBBarButtonItem.h"

@interface MBBarButtonItem ()
@end

@implementation MBBarButtonItem

- (void)setJumpURL:(NSString *)jumpURL {
    _jumpURL = jumpURL;
    if (jumpURL && !self.action) {
        self.action = @selector(_MBBarButtonItem_defaultAction);
        self.target = self;
    }
}


- (void)_MBBarButtonItem_defaultAction {
    if (self.jumpURL) {
        // @TODO
//        ZYNavigationControllerJumpWithURL(self.jumpURL);
    }
}

@end
