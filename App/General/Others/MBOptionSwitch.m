
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
    if (!ud) {
        dout_warning(@"Cannot read value as specified UserDefaults is nil.")
        return;
    }
    id value = [ud valueForKey:self.optionKey];
    if (!RFAssertKindOfClass(value, NSNumber.class)) {
        DebugLog(YES, nil, @"Except %@ to be a NSNumber, got %@.", self.optionKey, value);
        value = nil;
    }
    BOOL valueInConfig = [value boolValue];
    self.on = self.reversed? !valueInConfig : valueInConfig;
}

- (void)_MBOptionSwitch_onValueChanged {
    if (!self.optionKey) {
        dout_warning(@"Cannot save changes as optionKey is not set.")
        return;
    }
    __kindof NSUserDefaults *ud = self.sharedPreferences? AppUserDefaultsShared() : AppUserDefaultsPrivate();
    if (!ud) {
        dout_warning(@"Cannot save changes as specified UserDefaults is nil.")
        return;
    }
    [ud setValue:@(self.reversed? !self.on : self.on) forKey:self.optionKey];
    [ud setNeedsSynchronized];
}

@end
