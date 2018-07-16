/*!
 MBCollectionViewArrayDataSource
 
 Copyright © 2018 RFUI.
 Copyright © 2015-2016 Beijing ZhiYun ZhiYuan Information Technology Co., Ltd.
 https://github.com/BB9z/iOS-Project-Template

 Apache License, Version 2.0
 http://www.apache.org/licenses/LICENSE-2.0
 */
#import <MBAppKit/MBAppKit.h>

/**
 数组作为数据源的 data source
 
 提供：
 - 可选在正常数据前添加一个特殊 cell
 */
@interface MBCollectionViewArrayDataSource : NSObject <
    RFInitializing,
    UICollectionViewDataSource
>
@property (nonatomic, nullable, weak) IBOutlet UICollectionView *collectionView;

@property (nonatomic, nullable, strong) NSArray *items;

/**
 @param indexPath 为空会抛出异常
 */
- (nullable id)itemAtIndexPath:(nonnull NSIndexPath *)indexPath;

- (nullable NSIndexPath *)indexPathForItem:(nonnull id)item;

@property (nonatomic, nullable, copy) NSString *_Nonnull (^cellIdentifierProvider)(__kindof MBCollectionViewArrayDataSource *_Nonnull dataSource, id _Nonnull item, NSIndexPath *_Nonnull indexPath);

#pragma mark - Additional Item

/// 第一个特殊 cell 的标识
/// 设置则添加
@property (nonatomic, nullable, copy) IBInspectable NSString *firstItemReuseIdentifier;

/// 可选，绑定在第一个特殊 cell 的对象
@property (nonatomic, nullable, strong) id firstItemObject;

- (BOOL)isFirstItemIndexPath:(nonnull NSIndexPath *)indexPath;

/// 最后一个特殊 cell 的标识
/// 设置则添加
@property (nonatomic, nullable, copy) IBInspectable NSString *lastItemReuseIdentifier __attribute__((unavailable("暂未实现")));

/// 列表项最多元素个数，0 不限制
@property (nonatomic) IBInspectable NSUInteger maxItemsCount __attribute__((unavailable("暂未实现")));

@end
