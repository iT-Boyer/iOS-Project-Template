//
//  ZYVerifyTextField.h
//  Very+
//
//  Created by BB9z on 7/15/14.
//  Copyright (c) 2014 Beijing ZhiYun ZhiYuan Information Technology Co., Ltd. All rights reserved.
//

#import "MBTextField.h"
#import "RFRefreshButton.h"

typedef NS_ENUM(short, ZYVerifyTextFieldStatus) {
    ZYVerifyTextFieldStatusNone = 0,
    ZYVerifyTextFieldStatusChecking,
    ZYVerifyTextFieldStatusSuccess,
    ZYVerifyTextFieldStatusFail,
};

/**
 失去焦点后异步验证用户输入是否有效

 */
@interface ZYVerifyTextField : MBTextField

/// 切换属性以切换外观
@property (nonatomic) ZYVerifyTextFieldStatus status;

/**
 设置该对象会标记为开始请求
 
 会自动取消之前的操作，请求结束后需要手动修改 status 标记验证结果
 */
@property (weak, nonatomic) NSOperation *operation;

/// 上次检查的文本，可用来避免重复检查
@property (readonly, copy, nonatomic) NSString *lastCheckString;

@property (weak, nonatomic) IBOutlet UIView *verifyFaildNoticeView;

@property (strong, nonatomic) RFRefreshButton *indicatorButton;
@end
