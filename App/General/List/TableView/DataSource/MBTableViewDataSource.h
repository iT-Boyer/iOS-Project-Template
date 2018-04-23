/*!
    MBTableViewDataSource
    v 0.4

    Copyright © 2014-2015 Beijing ZhiYun ZhiYuan Information Technology Co., Ltd.
    https://github.com/Chinamobo/iOS-Project-Template

    Apache License, Version 2.0
    http://www.apache.org/licenses/LICENSE-2.0
 */
#import "MBListDataSource.h"

@interface MBTableViewDataSource : MBListDataSource <
    UITableViewDataSource
>
@property (weak, nonatomic) IBOutlet UITableView *tableView;

/// 暂不可用
@property (weak, nonatomic) id<UITableViewDataSource> delegate;

/**
 完成后，列表已经刷新完毕
 */
- (void)fetchItemsFromViewController:(id)viewController nextPage:(BOOL)nextPage success:(void (^)(MBTableViewDataSource *dateSource, NSArray *fetchedItems))success completion:(void (^)(MBTableViewDataSource *dateSource))completion;

/**
 Tableview 重载时是否添加动画
 
 @warning `YES` 有问题

 默认 `NO`
 */
@property (nonatomic) IBInspectable BOOL animationReload;

/**
 获取第一页时禁用动画效果

 默认 `NO`
 */
@property (nonatomic) IBInspectable BOOL animationReloadDisabledOnFirstPage;

#pragma mark - Cell 配置

/**
 可选，默认 Cell
 */
@property (copy, nonatomic) NSString *(^cellReuseIdentifier)(UITableView *tableView, NSIndexPath *indexPath, id item);

/**
 可选，默认在 cell 上执行 setItem 方法
 */
@property (copy, nonatomic) void (^configureCell)(UITableView *tableView, id cell, NSIndexPath *indexPath, id item, BOOL offscreenRendering);

@end
