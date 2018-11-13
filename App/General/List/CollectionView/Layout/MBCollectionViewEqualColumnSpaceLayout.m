
#import "MBCollectionViewEqualColumnSpaceLayout.h"
#import <RFKit/UIView+RFAnimate.h>

@interface MBCollectionViewEqualColumnSpaceLayout ()
@end

@implementation MBCollectionViewEqualColumnSpaceLayout

- (void)prepareLayout {
    [super prepareLayout];
    NSAssert(self.scrollDirection == UICollectionViewScrollDirectionVertical, @"Only vertical direction is supported.");
    NSUInteger columns = self.numberOfColumns;
    CGFloat itemSpace = (self.collectionView.width - self.itemSize.width * columns) / (columns + 1);
    
    UIEdgeInsets inset = self.sectionInset;
    inset.left = itemSpace;
    inset.right = itemSpace;
    self.sectionInset = inset;
    self.minimumInteritemSpacing = itemSpace;
    [self.collectionView invalidateIntrinsicContentSize];
}

@end
