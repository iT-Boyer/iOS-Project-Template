
#import "MBCollectionViewFlowLayout.h"

@implementation MBCollectionViewFlowLayout
RFInitializingRootForNSObjectSupportNSCoding

- (void)onInit {
}

- (void)afterInit {
    // Nothing
}

/// 尝试解决 iOS 9 上的 _createPreparedSupplementaryViewForElementOfKind 异常
/// ref: http://stackoverflow.com/a/32823057/945906
- (NSArray *)layoutAttributesForElementsInRect:(CGRect)rect {
    if (!self.collectionView.dataSource ) return nil;
    return [super layoutAttributesForElementsInRect:rect];
}

@end
