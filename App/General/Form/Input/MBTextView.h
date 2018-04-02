/*!
    MBTextView
    v 1.5

    Copyright © 2014 Beijing ZhiYun ZhiYuan Information Technology Co., Ltd.
    https://github.com/Chinamobo/iOS-Project-Template

    Apache License, Version 2.0
    http://www.apache.org/licenses/LICENSE-2.0
 */

#import "Common.h"

@class MBTextViewBackgroundImageView;

/**
 TextView 封装

 特性：

 - 为 TextView 增加了 placeholder
 - 使用 MBTextViewBackgroundImageView 为 TextView 增加背景边框，可随焦点高亮
 - 可以限制用户输入长度，超出限制长度表现为不可增加字符
 - 单行模式，使 TextView 变成一个可以显示多行文本的 TextFiled
 - 设置 scrollsToTop 为 NO

 已知问题：

 - placeholder 的行为和 UITextField 不一致，虽行为也是可以模仿的，但会增加不必要的复杂，暂不实现

 */
@interface MBTextView : UITextView <
    RFInitializing
>
@property (weak, nonatomic) IBOutlet MBTextViewBackgroundImageView *backgroundImageView;

#pragma mark - Place holder

/**
 占位文本
 
 默认把 nib 中已输入文本当作占位符，代码模式的话，不使用text属性
 */
@property (copy, nonatomic) IBInspectable NSString *placeholder;

/**
 默认使用 globalPlaceholderTextColor
 */
@property (strong, nonatomic) IBInspectable UIColor *placeholderTextColor;

#pragma mark -

/**
 限制最大输入长度
 */
@property (nonatomic) IBInspectable NSUInteger maxLength;

/**
 单行模式
 
 开启会移除用户输入的换行符
 */
@property (nonatomic) IBInspectable BOOL singleLineMode;

/**
 随输入文字自动展开文本框
 
 设为 YES 时，会随输入更新 intrinsicContentSize
 */
@property (nonatomic) IBInspectable BOOL autoExpandWhenInput;
@end

@interface MBTextViewBackgroundImageView : UIImageView <
    RFInitializing
>

@end