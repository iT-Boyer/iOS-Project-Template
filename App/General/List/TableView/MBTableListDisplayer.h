/*
 MBTableListDisplayer
 
 Copyright © 2018 RFUI.
 Copyright © 2015 Beijing ZhiYun ZhiYuan Information Technology Co., Ltd.
 https://github.com/BB9z/iOS-Project-Template
 
 The MIT License
 https://opensource.org/licenses/MIT
 */
#import "MBTableView.h"
#import "MBGeneralListDisplaying.h"

// @MBDependency:4
/**
 专用于嵌在其他界面的列表

 把显示、跳转可以封装在这里
 处理了嵌套 vc 取消请求的问题
 */
@interface MBTableListDisplayer : UITableViewController <
    RFInitializing,
    MBGeneralListDisplaying
>

@property (nonatomic) MBTableView *tableView;

@property (nonatomic) IBInspectable NSString *APIName;
@property (weak) MBTableViewDataSource *dataSource;

/// 默认不做什么
- (void)setupDataSource:(MBTableViewDataSource *)ds;

@end

// @MBDependency:3
/**
 嵌入了 MBTableListDisplayer 的普通 UIViewController，增加了便于修改 listDisplayer 的属性
 
 listDisplayer 正常通过 UIContainerView 或 RFContainerView 嵌入。不自动嵌入是考虑到列表的位置不总是固定填满的
 */
@interface MBTableListController : UIViewController <
    MBGeneralListDisplaying
>
@property (strong, nonatomic) IBInspectable NSString *APIName;

/**
 用于设置列表的默认 cell reuse identifier。复杂情况，有不同种类的 cell 时，请在 setupDataSource: 中设置 data source
 */
@property (strong, nonatomic) IBInspectable NSString *cellIdentifier;

/**
 手动，而不是 viewDidLoad 时立即刷新
 */
@property (nonatomic) IBInspectable BOOL disableAutoRefreshAfterViewLoadded;

@property (nonatomic) IBInspectable BOOL clearsSelectionOnViewWillAppear;

@property (strong, nonatomic) MBTableListDisplayer *listDisplayer;

- (UITableView *)listView;
- (MBTableViewDataSource *)dataSource;

/// 默认什么也不做
- (void)setupDataSource:(MBTableViewDataSource *)ds;

@end
