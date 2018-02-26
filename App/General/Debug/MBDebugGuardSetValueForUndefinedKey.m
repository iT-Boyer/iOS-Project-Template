
#import "MBDebugGuardSetValueForUndefinedKey.h"

#if RFDEBUG

@implementation UIView (MBDebugGuardSetValueForUndefinedKey)

- (void)setValue:(id)value forUndefinedKey:(NSString *)key {
    RFAssert(false, @"%@ is not key value coding-compliant for the key %@", self, key);
    [super setValue:value forUndefinedKey:key];
}

@end


@implementation UIViewController (MBDebugGuardSetValueForUndefinedKey)

- (void)setValue:(id)value forUndefinedKey:(NSString *)key {
    RFAssert(false, @"%@ is not key value coding-compliant for the key %@", self, key);
    [super setValue:value forUndefinedKey:key];
}

@end

#endif
