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
/**
 类里已内置了一个强引用的 MBCollectionViewDataSource

 外部不要直接使用 data source 的数据拉取方法，请使用 view 包装的
 */
@property (weak, null_resettable, nonatomic) MBCollectionViewDataSource *dataSource;

- (void)fetchItemsNextPage:(BOOL)nextPage success:(void (^__nullable)(MBCollectionViewDataSource *__nonnull dateSource, NSArray *__nullable fetchedItems))success completion:(void (^__nullable)(MBCollectionViewDataSource *__nonnull dateSource))completion;

/**
 移动到 window 时，如果之前数据没有成功加载，则尝试获取数据，默认关
 */
@property IBInspectable BOOL autoFetchWhenMoveToWindow;

#pragma mark - Header & footer

/// 默认 view 创建后如果 refreshControl 未设置会自动创建一个 UIRefreshControl
/// 如果不需要使用 refreshControl 需设置该属性为 YES
@property IBInspectable BOOL disableRefreshControl;

/// 在 collection view 顶部增加的区域，相当于 table view 的 tableHeaderView
/// 内部通过修改 contentInset 实现
@property (nullable, nonatomic) UIView *collectionHeaderView;

/**
 底部刷新视图

 默认不会创建，需要启用 footer supplementary view 且 id 为 "RefreshFooter"、类型为 MBCollectionRefreshFooterView。view 结构可参考 MBCollectionRefreshFooterView.xib
 */
@property (nullable, nonatomic) MBCollectionRefreshFooterView *refreshFooterView;

/// 用于对 refreshFooterView 进行定制，因为其不会立即载入
@property (nullable) void (^refreshFooterConfig)(MBCollectionRefreshFooterView *__nonnull);

/// 重置，以便作为另一个列表展示
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
@property (weak, nullable) IBOutlet UIView *contentView;

/**
 正常情况下，不需要调用下面的方法，contentView 高度发生变化时会自动更新相关视图
 */
- (void)updateHeight;
- (void)updateHeightAnimated:(BOOL)animated;

@end
