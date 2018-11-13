/*
 MBTextCountLabel
 
 Copyright © 2018 RFUI.
 https://github.com/BB9z/iOS-Project-Template
 
 Apache License, Version 2.0
 http://www.apache.org/licenses/LICENSE-2.0
 */

#import <RFInitializing/RFInitializing.h>
#import <RFKit/RFRuntime.h>

// @MBDependency:2
/**
 显示关联 textView 的文字长度，若超出指定长度，label 将变为高亮状态
 */
@interface MBTextCountLabel : UILabel <
    RFInitializing
>

/**
 
 */
@property (weak, nullable, nonatomic) IBOutlet UITextView *textView;

/**
 关联的 textView 若超出指定长度，label 将变为高亮状态
 
 为 0 只更新当前字符数，不显示超出状态
 */
@property (nonatomic) IBInspectable NSUInteger maxLength;

/**
 如果用代码设置 textView 的文本，label 状态不会更新，可用该方法强制更新
 */
- (void)updateUIForTextChanged;
@end
