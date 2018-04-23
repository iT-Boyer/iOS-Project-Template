/*!
 MBFormFieldVerifyControl
 
 Copyright © 2018 RFUI.
 https://github.com/BB9z/iOS-Project-Template
 
 Apache License, Version 2.0
 http://www.apache.org/licenses/LICENSE-2.0
 */
#import "Common.h"

@class MBTextField;

/**
 关联一组输入框和按钮，如果都验证通过使按钮 enable，否则 disable
 */
@interface MBFormFieldVerifyControl : NSObject

@property (nonatomic, nullable) IBOutletCollection(MBTextField) NSArray *textFields;

/// UIControl 或 bar button item
@property (nonatomic, nullable, weak) IBOutlet id submitButton;
@end
