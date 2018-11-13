/*
 MBCollectionView
 
 Copyright © 2018 RFUI.
 Copyright © 2014-2016 Beijing ZhiYun ZhiYuan Information Technology Co., Ltd.
 https://github.com/BB9z/iOS-Project-Template

 Apache License, Version 2.0
 http://www.apache.org/licenses/LICENSE-2.0
 */
#import <RFKit/RFRuntime.h>
#import "MBCollectionRefreshFooterView.h"
#import "MBCollectionViewDataSource.h"

// @MBDependency:1
@interface MBCollectionView : UICollectionView <
    RFInitializing
>
@property (weak, nonatomic) MBCollectionViewDataSource *dataSource;

/**
 MBCollectionView 真正请求的 dataSource
 如果在 MBCollectionView 创建后没有设置，会自动创建一个内建的
 设置该属性会自动设置 MBCollectionViewDataSource 的 collectionView 属性
 */
@property (strong, nonatomic) MBCollectionViewDataSource *trueDataSource;

#pragma mark - Header & footer

@property (strong, nonatomic) UIView *collectionHeaderView;

@property (strong, nonatomic) UIRefreshControl *mb_refreshControl;
@property (strong, nonatomic) MBCollectionRefreshFooterView *refreshFooterView;

@property (weak, nonatomic) UIView *headerView;

- (void)prepareForReuse;
@end


/**
 这类只能于 MBCollectionView，用来给 MBCollectionView 增加一个自适应高度的 header，其高度只能用 Auto Layout 控制。
 
 使用：
 - 把想要呈现的视图放在 contentView 中，用约束撑起（跟用 Auto Layout 撑起 UIScrollView 同理），该视图保持自身与 contentView 等高。
 - contentView 也要设置约束，但需要注意只应设置左右与上三个方向的约束，底部留空
 
 - 如果 contentView 为空，其高度将不会自动更新，你需要设置 MBCollectionViewHeaderFooterView 并手动调用 updateHeight，该方式并不推荐
 */
@interface MBCollectionViewHeaderFooterView : UIView <
    RFInitializing
>
@property (weak, nonatomic) IBOutlet UIView *contentView;

/**
 正常情况下，不需要调用下面的方法，contentView 高度发生变化时会自动更新相关视图
 */
- (void)updateHeight;
- (void)updateHeightAnimated:(BOOL)animated;

@end
