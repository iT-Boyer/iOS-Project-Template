/*!
    MBFormViewController
    v 1.1

    Copyright © 2014 Beijing ZhiYun ZhiYuan Information Technology Co., Ltd.
    https://github.com/Chinamobo/iOS-Project-Template

    Apache License, Version 2.0
    http://www.apache.org/licenses/LICENSE-2.0
 */

#import "Common.h"

/**
 简单的表单提交基础类
 
 通常使用静态的 UITableViewController
 */
@interface MBFormViewController : UITableViewController

#pragma mark - Methods for overwrite

/**
 子类在最后调用 super
 */
- (BOOL)checkFields;

/**
 子类在开头调用 super
 */
- (IBAction)onSubmit:(id)sender;
@end
