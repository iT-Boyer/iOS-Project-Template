
#import "MBOptionSwitch.h"
#import "MBApp.h"

@implementation MBOptionSwitch
RFInitializingRootForUIView

- (void)onInit {
    [self addTarget:self action:@selector(_MBOptionSwitch_onValueChanged) forControlEvents:UIControlEventValueChanged];
}

- (void)afterInit {
}

- (void)willMoveToWindow:(UIWindow *)newWindow {
    [super willMoveToWindow:newWindow];

    if (!newWindow) return;
    if (!self.optionKey) return;

    __kindof NSUserDefaults *ud = self.sharedPreferences? AppUserDefaultsShared() : AppUserDefaultsPrivate();
    id value = [ud valueForKey:self.optionKey];
    RFAssertKindOfClass(value, NSNumber.class);
    BOOL valueInConfig = [value boolValue];
    self.on = self.reversed? !valueInConfig : valueInConfig;
}

- (void)_MBOptionSwitch_onValueChanged {
    if (!self.optionKey) return;

    __kindof NSUserDefaults *ud = self.sharedPreferences? AppUserDefaultsShared() : AppUserDefaultsPrivate();
    [ud setValue:@(self.reversed? !self.on : self.on) forKey:self.optionKey];
    [ud setNeedsSynchronized];
}

@end
