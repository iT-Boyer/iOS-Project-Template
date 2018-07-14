
#import "NSUserDefaults+MBDebug.h"
#import <MBAppKit/MBUserDefaultsMakeProperty.h>

@implementation NSUserDefaults (MBDebug)

#if DEBUG
+ (void)load {
    NSUserDefaults *ud = NSUserDefaults.standardUserDefaults;
    ud._debugEnabled = YES;
}
#endif

_makeBoolProperty(_debugEnabled, set_debugEnabled);

_makeBoolProperty(_debugAPIAllowSSLDebug, set_debugAPIAllowSSLDebug)

@end
