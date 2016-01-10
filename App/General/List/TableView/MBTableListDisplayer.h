/*!
    MBTableListDisplayer

    Copyright © 2015 Beijing ZhiYun ZhiYuan Information Technology Co., Ltd.
    https://github.com/Chinamobo/iOS-Project-Template

    Apache License, Version 2.0
    http://www.apache.org/licenses/LICENSE-2.0
 */
#import "MBTableView.h"
#import "MBEntityListDisplaying.h"

/**
 专用于嵌在其他界面的列表

 把显示、跳转可以封装在这里
 处理了嵌套 vc 取消请求的问题
 */
@interface MBTableListDisplayer : UITableViewController <
    RFInitializing,
    MBEntityListDisplaying
>

@property (nonatomic, retain) MBTableView *tableView;

@property (copy, nonatomic) IBInspectable NSString *APIName;
@property (weak, nonatomic) MBTableViewDataSource *dataSource;

/// 默认不做什么
- (void)setupDataSource:(MBTableViewDataSource *)ds;

/**
 默认依次尝试取 sender、tableViewCell、self 的 item，然后交给 destinationViewController
 */
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender;
@end


/**
 嵌入了 MBTableListDisplayer 的普通 UIViewController，增加了便于修改 listDisplayer 的属性
 
 listDisplayer 正常通过 UIContainerView 或 RFContainerView 嵌入。不自动嵌入是考虑到列表的位置不总是固定填满的
 */
@interface MBTableListController : UIViewController <
    MBEntityListDisplaying
>
@property (strong, nonatomic) IBInspectable NSString *APIName;

/**
 用于设置列表的默认 cell reuse identifier。复杂情况，有不同种类的 cell 时，请在 setupDataSource: 中设置 data source
 */
@property (strong, nonatomic) IBInspectable NSString *cellIdentifier;

/**
 手动，而不是 viewDidLoad 时立即刷新
 */
@property (assign, nonatomic) IBInspectable BOOL disableAutoRefreshAfterViewLoadded;

@property (assign, nonatomic) IBInspectable BOOL clearsSelectionOnViewWillAppear;

@property (strong, nonatomic) MBTableListDisplayer *listDisplayer;

- (UITableView *)listView;
- (MBTableViewDataSource *)dataSource;

/// 默认什么也不做
- (void)setupDataSource:(MBTableViewDataSource *)ds;

@end