/*!
    MBTextView
    v 1.0

    Copyright © 2014 Beijing ZhiYun ZhiYuan Information Technology Co., Ltd.
    https://github.com/Chinamobo/iOS-Project-Template

    Apache License, Version 2.0
    http://www.apache.org/licenses/LICENSE-2.0
 */
#import "RFUI.h"

/**
 TextView 封装

 特性：

 - 为 TextView 增加了 placeholder
 - 使用 MBTextViewBackgroundImageView 为 TextView 增加背景边框，可随焦点高亮
 - 可以限制用户输入长度，超出限制长度表现为不可增加字符
 - 单行模式，使 TextView 变成一个可以显示多行文本的 TextFiled

 已知问题：

 - placeholder 的行为和 UITextField 不一致，虽行为也是可以模仿的，但会增加不必要的复杂，暂不实现

 */
@interface MBTextViewBackgroundImageView : UIImageView <
    RFInitializing
>

@end

@interface MBTextView : UITextView <
    RFInitializing
>
@property (weak, nonatomic) IBOutlet MBTextViewBackgroundImageView *backgroundImageView;

/**
 占位文本
 
 默认把 nib 中已输入文本当作占位符
 */
@property (copy, nonatomic) NSString *placeholder;

/**
 默认使用 globalPlaceholderTextColor
 */
@property (strong, nonatomic) UIColor *placeholderTextColor UI_APPEARANCE_SELECTOR;

/**
 限制最大输入长度
 */
@property (assign, nonatomic) NSUInteger maxLength;

/**
 单行模式
 
 开启会移除用户输入的换行符
 */
@property (assign, nonatomic) BOOL singleLineMode;
@end
