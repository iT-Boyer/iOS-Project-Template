/*!
 MBEntitiesCollectionView
 
 Copyright © 2018 RFUI.
 Copyright © 2014-2016 Beijing ZhiYun ZhiYuan Information Technology Co., Ltd.
 https://github.com/BB9z/iOS-Project-Template
 
 Apache License, Version 2.0
 http://www.apache.org/licenses/LICENSE-2.0
 */

#import "Common.h"

/**
 一个简单快速的 collection view 子类：
 
 - 数组作为单 setion 的数据源
 - 默认 reuse identifier 为 "Cell"
 - Cell 点击时尝试执行 cell 的 onCellSelected 方法
 - 默认 scrollsToTop 为 NO
 */
@interface MBEntitiesCollectionView<ItemType> : UICollectionView <
    RFInitializing,
    UICollectionViewDataSource,
    UICollectionViewDelegate
>
/// 设置时重载
@property (nonatomic, nullable) NSArray<ItemType> *items;

/**
 可选 cell 设置 block，默认直接给 item
 */
@property (nullable) void (^cellConfigBlock)(__kindof UICollectionViewCell *__nonnull cell, ItemType __nonnull item);

@end
