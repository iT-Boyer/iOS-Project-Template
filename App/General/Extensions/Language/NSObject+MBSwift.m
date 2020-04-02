
#import "NSObject+MBSwift.h"

@implementation NSObject (MBSwift)

+ (instancetype)mbswift_instanceType:(id)object {
    NSParameterAssert([object isKindOfClass:self.class]);
    return object;
}

@end
