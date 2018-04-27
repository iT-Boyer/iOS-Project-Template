//
//  MBFormTextField.h
//  Beast
//
//  Created by BB9z on 6/11/14.
//  Copyright (c) 2014 Chinamobo. All rights reserved.
//

#import "Common.h"
#import "MBTextField.h"

/**
 这个类在其内容修改后，尝试利用 KVO 修改其所属 view controler 中 item 属性的字段
 
 修改触发的时机在 textFieldDidEndEditing:
 */
@interface MBFormTextField : MBTextField <
    UITextFieldDelegate
>

/**
 item 对应的字段名
 */
@property (copy, nonatomic) NSString *name;
@end
