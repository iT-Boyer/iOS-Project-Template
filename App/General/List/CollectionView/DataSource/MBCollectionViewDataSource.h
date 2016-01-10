/*!
    MBCollectionViewDataSource
    v 0.1

    Copyright © 2014-2015 Beijing ZhiYun ZhiYuan Information Technology Co., Ltd.
    https://github.com/Chinamobo/iOS-Project-Template

    Apache License, Version 2.0
    http://www.apache.org/licenses/LICENSE-2.0
 */
#import "MBListDataSource.h"

@interface MBCollectionViewDataSource : MBListDataSource <
    UICollectionViewDataSource
>
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;

- (void)fetchItemsFromViewController:(id)viewController nextPage:(BOOL)nextPage success:(void (^)(MBCollectionViewDataSource *dateSource, NSArray *fetchedItems))success completion:(void (^)(MBListDataSource *dateSource))completion;

- (void)fetchNextPageFromViewController:(id)viewController completion:(void (^)(MBListDataSource *dateSource))completion;

#pragma mark -
@property (copy, nonatomic) NSString *(^cellReuseIdentifier)(UICollectionView *collectionView, NSIndexPath *indexPath, id item);
@property (copy, nonatomic) void (^configureCell)(UICollectionView *collectionView, id cell, NSIndexPath *indexPath, id item);

@end
