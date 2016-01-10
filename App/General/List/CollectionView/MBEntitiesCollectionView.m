
#import "MBEntitiesCollectionView.h"
#import "MBEntityExchanging.h"

@implementation MBEntitiesCollectionView
RFInitializingRootForUIView

- (void)onInit {
    self.dataSource = self;
    self.scrollsToTop = NO;
}

- (void)afterInit {
    // Nothing
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.items.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewCell<MBEntityExchanging> *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"Cell" forIndexPath:indexPath];
    if (self.cellConfigBlock) {
        self.cellConfigBlock(cell, self.items[indexPath.item]);
    }
    else {
        cell.item = self.items[indexPath.item];
    }
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    MBCollectionViewCell *cell = (id)[collectionView cellForItemAtIndexPath:indexPath];
    if ([cell respondsToSelector:@selector(onCellSelected)]) {
        [cell onCellSelected];
    }
}

- (void)setItems:(NSArray *)items {
    if (_items != items) {
        _items = items;
        [self reloadData];
    }
}

@end