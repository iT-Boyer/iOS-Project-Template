/*!
    MBTableView
    v 1.3

    Copyright © 2014 Beijing ZhiYun ZhiYuan Information Technology Co., Ltd.
    Copyright © 2014 Chinamobo Co., Ltd.
    https://github.com/Chinamobo/iOS-Project-Template

    Apache License, Version 2.0
    http://www.apache.org/licenses/LICENSE-2.0
 */
#import "RFUI.h"
#import "MBTableViewPullToFetchControl.h"
#import "RFTableViewCellHeightDelegate.h"
#import "MBEntityExchanging.h"
#import "MBTableViewDataSource.h"

@protocol MBTableViewDelegate;

/**
 Table view 基类

 封装了分页的数据获取（包括下拉刷新、上拉加载更多，数据到底处理），Auto layout cell 自动高度等功能。

 */
@interface MBTableView : UITableView <
    RFInitializing
>
@property (strong, nonatomic) RFTableViewCellHeightDelegate *cellHeightManager;
@property (strong, nonatomic) MBTableViewPullToFetchControl *pullToFetchController;

/**
 类里已内置了一个强引用的 MBTableViewDataSource
 */
@property (weak, nonatomic) MBTableViewDataSource *dataSource;

/**
 获取数据
 
 pullToFetchController 触发获取操作时调用的就是这个方法，如果要静默更新则可手动调用该方法
 */
- (void)fetchItemsWithPageFlag:(BOOL)nextPage;

/// 刷新数据，会重置 cell 高度缓存
- (void)reload;

/**
 从列表中删除一个对象的傻瓜方法，会设置好其他该设置的状态
 */
- (void)removeItem:(id)item withRowAnimation:(UITableViewRowAnimation)animation;

/// 重置，以便作为另一个表格展示
- (void)prepareForReuse;

#pragma mark -
- (void)updateCellHeightOfCell:(UITableViewCell *)cell animated:(BOOL)animated;
- (void)updateCellHeightAtIndexPath:(NSIndexPath *)indexPath animated:(BOOL)animated;

@end


/*! Change log
 
 1.0
 - dataSource 变成对象
 
 0.4
 - 移除 MBTableViewCellEntityExchanging，改用 MBSenderEntityExchanging
 
 0.3
 - 增加更新 cell 高度的方法
 - 补上内容为空的状态更新

 0.2
 - 把分页、数据获取等逻辑真正集成进来

 */
