/*
 MBDebugFloatConsoleViewController
 MBDebug
 
 Copyright © 2018 RFUI.
 Copyright © 2016 Beijing ZhiYun ZhiYuan Technology Co., Ltd. https://github.com/BB9z/iOS-Project-Template
 
 The MIT License
 https://opensource.org/licenses/MIT
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
