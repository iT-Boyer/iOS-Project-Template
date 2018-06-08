/*!
 ZYSMSCodeSendButton
 
 Copyright © 2018 RFUI.
 Copyright © 2014 Beijing ZhiYun ZhiYuan Technology Co., Ltd.
 https://github.com/BB9z/iOS-Project-Template
 
 Apache License, Version 2.0
 http://www.apache.org/licenses/LICENSE-2.0
 */

#import "MBButton.h"

/**
 短信发送按钮
 
 对刷新逻辑进行了封装。推荐使用方式：
 
 1. IB 中设置按钮类
 2. 设置 noraml 状态的文字，如「发送」
 3. 设置 disabled 状态的文字，如「%d 秒后重发」
 4. 可选设置 frozeSecond
 5. 短信发送成功后调用 froze 方法
 
 */
@interface ZYSMSCodeSendButton : MBButton

/**
 发送短信后显示的文字
 
 必须包含 %d 或其他整型格式化字符，例如：@"%d 秒后重发"
 默认设置为 Storyboard 中 Disabled 状态的标题
 */
@property (nullable) NSString *disableNoticeFormat;

/**
 短信发送后按钮禁用的时长
 
 默认 60s
 */
@property (nonatomic) IBInspectable NSUInteger frozeSecond;

/**
 短信发送后按钮解禁的时间，timeIntervalSinceReferenceDate
 */
@property NSTimeInterval unfreezeTime;

/**
 冻结按钮，进入倒计时
 
 在短信发送成功后调用
 */
- (void)froze;

@end
