/*!
    MBTableViewController

    Copyright © 2015 Beijing ZhiYun ZhiYuan Information Technology Co., Ltd.
    https://github.com/Chinamobo/iOS-Project-Template

    Apache License, Version 2.0
    http://www.apache.org/licenses/LICENSE-2.0
 */
#import "MBTableView.h"
#import "MBEntityListDisplaying.h"

/**
 比普通 UIViewController + MBTableView 多了以下特性：

 - MBEntityListDisplaying 协议支持
 - tableView:didSelectRowAtIndexPath: 时尝试执行 cell 的 onCellSelected 方法
 - 视图显示时取消选中单元
 - 适合 table view 的 segue 准备方法
 */
@interface MBTableViewController : UIViewController <
    MBEntityListDisplaying
>
@property (weak, nonatomic) IBOutlet MBTableView *listView;

@end
