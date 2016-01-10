/*!
    MBEntitiesCollectionView

    Copyright © 2014-2016 Beijing ZhiYun ZhiYuan Information Technology Co., Ltd.
    https://github.com/Chinamobo/iOS-Project-Template

    Apache License, Version 2.0
    http://www.apache.org/licenses/LICENSE-2.0
 */

#import "MBCollectionViewCell.h"

@interface MBEntitiesCollectionView : UICollectionView <
    UICollectionViewDataSource,
    RFInitializing
>
@property (strong, nonatomic) NSArray *items;

/**
 可选 cell 设置 block，默认直接给 item
 */
@property (copy, nonatomic) void (^cellConfigBlock)(id cell, id item);

@end
