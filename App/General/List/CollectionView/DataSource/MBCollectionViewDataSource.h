/*
 MBCollectionViewDataSource
 
 Copyright © 2018 RFUI.
 Copyright © 2014-2015 Beijing ZhiYun ZhiYuan Information Technology Co., Ltd.
 https://github.com/BB9z/iOS-Project-Template
 
 Apache License, Version 2.0
 http://www.apache.org/licenses/LICENSE-2.0
 */

#import "MBListDataSource.h"

// @MBDependency:3
/**
 单一 sction，可从服务器上分页获取数据的数据源
 */
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
