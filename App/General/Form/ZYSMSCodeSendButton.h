//
//  ZYSMSCodeSendButton.h
//  Very+
//
//  Created by BB9z on 7/14/14.
//  Copyright (c) 2014 Beijing ZhiYun ZhiYuan Information Technology Co., Ltd. All rights reserved.
//

#import "MBButton.h"

@interface ZYSMSCodeSendButton : MBButton

/**
 例如：@"%d 秒后重发"
 默认设置为 Storyboard 中 Disabled 状态的标题
 */
@property (copy, nonatomic) NSString *disableNoticeFormat;

/// 默认 60s
@property (nonatomic) NSUInteger frozeSecond;

/// 到期时间
@property (nonatomic) NSTimeInterval unfreezeTime;

/// 冻结按钮，进入倒计时
- (void)froze;
@end
