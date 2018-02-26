
#import "RFReferenceSizing.h"

double RFReferenceSizeRate(CGFloat referenceSize, CGFloat constant, CGFloat factor) {
    NSCParameterAssert(referenceSize != 0);
    return (constant / referenceSize - 1) * (factor?: 1) + 1;
}
