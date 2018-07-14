/*!
 MBDebugFloatConsoleViewController
 MBDebug
 
 Copyright © 2018 RFUI.
 Copyright © 2016 Beijing ZhiYun ZhiYuan Technology Co., Ltd. https://github.com/BB9z/iOS-Project-Template
 
 Apache License, Version 2.0
 http://www.apache.org/licenses/LICENSE-2.0
 */

#import <UIKit/UIKit.h>

/**
 调试浮层
 */
@interface MBDebugFloatConsoleViewController : UIViewController <
    UITableViewDataSource,
    UITableViewDelegate
>

@property (nonatomic, weak) IBOutlet UITableView *buildInList;
@property (nonatomic, weak) IBOutlet UITableView *contextList;

- (IBAction)onHide:(id)sender;

@end
