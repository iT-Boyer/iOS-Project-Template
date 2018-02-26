
#import "MBCollectionViewColumnLayout.h"

@interface MBCollectionViewColumnLayout ()
@property (weak, nonatomic) id<UICollectionViewDelegateFlowLayout> delegateRefrence;
@end

@implementation MBCollectionViewColumnLayout
@dynamic delegateRefrence;

- (void)onInit {
    [super onInit];
    if (self.columnCount <= 0) {
        self.columnCount = 3;
    }
}

- (void)awakeFromNib {
    [super awakeFromNib];
    self.referenceItemSize = self.itemSize;
}

- (id<UICollectionViewDelegateFlowLayout>)delegateRefrence {
    return (id)self.collectionView.delegate;
}

- (void)setColumnCount:(NSInteger)columnCount {
    if (_columnCount != columnCount) {
        _columnCount = columnCount;
        if (!self.autoColumnDecideOnItemMinimumWidth) {
            [self invalidateLayout];
        }
    }
}

- (CGFloat)innerLayoutWidthForSection:(NSInteger)section {
    UIEdgeInsets sectionInset;
    if ([self.delegateRefrence respondsToSelector:@selector(collectionView:layout:insetForSectionAtIndex:)]) {
        sectionInset = [self.delegateRefrence collectionView:self.collectionView layout:self insetForSectionAtIndex:section];
    } else {
        sectionInset = self.sectionInset;
    }
    return self.collectionView.frame.size.width - sectionInset.left - sectionInset.right;
}

- (CGFloat)itemWidthInSectionAtIndex:(NSInteger)section {
    CGFloat width = [self innerLayoutWidthForSection:section];
    NSInteger columnCount = self.columnCount;
    if (columnCount < 1) {
        columnCount = 1;
    }
    CGFloat itemWidth = floorf((width - (columnCount - 1) * self.minimumInteritemSpacing) / columnCount);
    return itemWidth;
}

- (void)prepareLayout {
    CGSize reference = self.referenceItemSize;
    if (self.autoColumnDecideOnItemMinimumWidth) {
        CGFloat width = [self innerLayoutWidthForSection:0];
        self.columnCount = width/self.referenceItemSize.width;
    }

    CGFloat itemWidth = [self itemWidthInSectionAtIndex:0];
    self.itemSize = CGSizeMake(itemWidth, itemWidth/reference.width*reference.height);
    [super prepareLayout];
}

- (BOOL)shouldInvalidateLayoutForBoundsChange:(CGRect)newBounds {
    CGRect oldBounds = self.collectionView.bounds;
    if (CGRectGetWidth(oldBounds) != CGRectGetWidth(newBounds)) {
        return YES;
    }
    return [super shouldInvalidateLayoutForBoundsChange:newBounds];
}

@end
