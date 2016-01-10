
#import "MBCollectionViewDataSource.h"
#import "MBEntityExchanging.h"

@implementation MBCollectionViewDataSource

- (void)onInit {
    [super onInit];
    if (!self.cellReuseIdentifier) {
        [self setCellReuseIdentifier:^NSString *(UICollectionView *collectionView, NSIndexPath *indexPath, id item) {
            return @"Cell";
        }];
    }

    if (!self.configureCell) {
        [self setConfigureCell:^(UICollectionView *collectionView, id<MBSenderEntityExchanging> cell, NSIndexPath *indexPath, id item) {
            if ([cell respondsToSelector:@selector(setItem:)]) {
                [cell setItem:item];
            }
        }];
    }
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.items.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    id item = [self itemAtIndexPath:indexPath];
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:self.cellReuseIdentifier(collectionView, indexPath, item) forIndexPath:indexPath];
    RFAssert(cell, nil);
    self.configureCell(collectionView, cell, indexPath, item);
    return cell;
}

- (void)fetchItemsFromViewController:(id)viewController nextPage:(BOOL)nextPage success:(void (^)(MBCollectionViewDataSource *, NSArray *))success completion:(void (^)(MBListDataSource *))completion {
    @autoreleasepool {
        [super fetchItemsFromViewController:viewController nextPage:nextPage success:(id)success completion:completion];
    }
}

- (void)fetchNextPageFromViewController:(id)viewController completion:(void (^)(MBListDataSource *dateSource))completion {
    [self fetchItemsFromViewController:viewController nextPage:YES success:^(MBCollectionViewDataSource *dateSource, NSArray *fetchedItems) {
        [dateSource.collectionView reloadData];
    } completion:completion];
}

// 这个方法没有 forward 到 delegate？
- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    if ([self.delegate respondsToSelector:@selector(collectionView:viewForSupplementaryElementOfKind:atIndexPath:)]) {
        return [self.delegate collectionView:collectionView viewForSupplementaryElementOfKind:kind atIndexPath:indexPath];
    }
    return nil;
}

@end
