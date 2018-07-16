/*!
 APUser
 
 Copyright © 2018 RFUI.
 Copyright © 2016 Beijing ZhiYun ZhiYuan Technology Co., Ltd.
 https://github.com/BB9z/iOS-Project-Template

 Apache License, Version 2.0
 http://www.apache.org/licenses/LICENSE-2.0
 */
#import <MBAppKit/MBAppKit.h>
#import <MBAppKit/MBUser.h>
#import <MBAppKit/MBUserDefaults.h>
#import "APUserInfo.h"

@interface APUser : MBUser

#pragma mark - 状态

/**
 用户基本信息
 
 不为空，操作上可以便捷一些
 */
@property (nonnull) APUserInfo *information;

@property (nonatomic, nullable) NSString *token;

#pragma mark - 挂载

@property (nonatomic, nullable, readonly) NSAccountDefaults *profile;

#pragma mark - 流程

/// 应用启动后初始流程
+ (void)setup;

@property BOOL hasLoginedThisSession;

/**
 @param complation item 参数是 APUserInfo。如果传空且 viewController 非空，默认出错弹窗
 */
- (void)updateInformationFromViewController:(nullable UIViewController *)viewController complation:(nullable MBGeneralCallback)complation;

@end
