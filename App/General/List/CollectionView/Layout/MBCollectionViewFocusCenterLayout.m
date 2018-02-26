//
//  MBCollectionViewFocusCenterLayout.m
//  Feel
//
//  Created by ddhjy on 21/11/2016.
//  Copyright © 2016 Beijing ZhiYun ZhiYuan Technology Co., Ltd. All rights reserved.
//

#import "MBCollectionViewFocusCenterLayout.h"

@implementation MBCollectionViewFocusCenterLayout
RFInitializingRootForNSObject
@dynamic pageWidth;

- (void)onInit {
    self.scrollDirection = UICollectionViewScrollDirectionHorizontal;
}

- (void)afterInit {
}

- (CGFloat)pageWidth {
    return self.itemSize.width + self.minimumInteritemSpacing - 5;
}

- (BOOL)shouldInvalidateLayoutForBoundsChange:(CGRect)newBounds {
    CGRect oldBounds = self.collectionView.bounds;
    if (CGRectGetWidth(oldBounds) != CGRectGetWidth(newBounds)) {
        return YES;
    }
    return [super shouldInvalidateLayoutForBoundsChange:newBounds];
}

- (void)prepareLayout {
    [super prepareLayout];
    
    CGFloat padding = (self.collectionView.bounds.size.width - self.itemSize.width) * 0.5;
    self.sectionInset = UIEdgeInsetsMake(0, padding, 0, (self.collectionView.bounds.size.width - self.itemSize.width) * 0.5);
}

- (CGPoint)targetContentOffsetForProposedContentOffset:(CGPoint)proposedContentOffset withScrollingVelocity:(CGPoint)velocity {
    CGFloat rawPageValue = self.collectionView.contentOffset.x / self.pageWidth;
    CGFloat currentPage = (velocity.x > 0.0) ? floor(rawPageValue) : ceil(rawPageValue);
    CGFloat nextPage = (velocity.x > 0.0) ? ceil(rawPageValue) : floor(rawPageValue);
    
    BOOL pannedLessThanAPage = fabs(1 + currentPage - rawPageValue) > 0.5;
    BOOL flicked = fabs(velocity.x) > [self flickVelocity];
    if (pannedLessThanAPage && flicked) {
        proposedContentOffset.x = nextPage * self.pageWidth;
    } else {
        proposedContentOffset.x = round(rawPageValue) * self.pageWidth;
    }
    
    return proposedContentOffset;
}

- (CGFloat)flickVelocity {
    return 0.3;
}

@end
