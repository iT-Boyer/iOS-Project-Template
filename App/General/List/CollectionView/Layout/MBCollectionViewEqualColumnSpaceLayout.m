
#import "MBCollectionViewEqualColumnSpaceLayout.h"

@interface MBCollectionViewEqualColumnSpaceLayout ()

@property (nonatomic) CGFloat lastYValue;
@property (strong, nonatomic) NSMutableDictionary<NSIndexPath *, UICollectionViewLayoutAttributes *> *layoutInfo;

@end


@implementation MBCollectionViewEqualColumnSpaceLayout

- (void)onInit {
    [super onInit];
    
    _layoutInfo = [NSMutableDictionary dictionary];
}

- (void)prepareLayout {
    NSUInteger currentColumn = 0;
    CGFloat fullWidth = self.collectionView.frame.size.width;
    CGFloat itemWidth = self.itemSize.width;
    CGFloat itemHeight = self.itemSize.height;
    CGFloat itemSpace = (fullWidth - itemWidth * self.numberOfColumns) / (self.numberOfColumns + 1);
    NSIndexPath *indexPath;
    NSUInteger numItems = [self.collectionView numberOfItemsInSection:0];
    for (NSUInteger item = 0; item < numItems; item++) {
        indexPath = [NSIndexPath indexPathForItem:item inSection:0];
        
        self.layoutInfo[indexPath] = ({
            UICollectionViewLayoutAttributes *itemAttributes = [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:indexPath];
            CGFloat x = itemSpace + (itemSpace + itemWidth) * currentColumn;
            CGFloat y = self.lastYValue;
            itemAttributes.frame = CGRectMake(x, y, itemWidth, itemHeight);
            itemAttributes;
        });
        
        if (item % self.numberOfColumns == self.numberOfColumns - 1) {
            self.lastYValue += itemHeight + self.minimumLineSpacing;
        }
        
        currentColumn++;
        if (currentColumn == self.numberOfColumns) currentColumn = 0;
    }
}

- (NSArray<UICollectionViewLayoutAttributes *> *)layoutAttributesForElementsInRect:(CGRect)rect {
    NSMutableArray *allAttributes = [NSMutableArray arrayWithCapacity:self.layoutInfo.count];
    
    [self.layoutInfo enumerateKeysAndObjectsUsingBlock:^(NSIndexPath *indexPath, UICollectionViewLayoutAttributes *attributes, BOOL *stop) {
        if (CGRectIntersectsRect(rect, attributes.frame)) {
            [allAttributes addObject:attributes];
        }
    }];
    
    return allAttributes;
}

-(CGSize) collectionViewContentSize {
    return CGSizeMake(self.collectionView.frame.size.width, self.lastYValue);
}

@end
