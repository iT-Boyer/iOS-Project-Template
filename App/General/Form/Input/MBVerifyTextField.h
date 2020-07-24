/*
 MBVerifyTextField
 
 Copyright © 2018, 2020 RFUI.
 Copyright © 2014, 2016 Beijing ZhiYun ZhiYuan Technology Co., Ltd.
 https://github.com/BB9z/iOS-Project-Template
 
 The MIT License
 https://opensource.org/licenses/MIT
 */

#import "MBTextField.h"
#import "RFRefreshButton.h"

typedef NS_ENUM(short, MBVerifyTextFieldStatus) {
    MBVerifyTextFieldStatusNone = 0,
    MBVerifyTextFieldStatusChecking,
    MBVerifyTextFieldStatusSuccess,
    MBVerifyTextFieldStatusFail,
};

// @MBDependency:1
/**
 失去焦点后异步验证用户输入是否有效

 */
@interface MBVerifyTextField : MBTextField

/// 切换属性以切换外观
@property (nonatomic) MBVerifyTextFieldStatus status;

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
