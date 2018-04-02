//
//  APINetworkActivityManager.h
//  Feel
//
//  Created by BB9z on 10/28/14.
//  Copyright (c) 2014 Beijing ZhiYun ZhiYuan Information Technology Co., Ltd. All rights reserved.
//

#import <RFSVProgressMessageManager.h>

@interface APINetworkActivityManager : RFSVProgressMessageManager

#pragma mark - 便捷方法

/**
 显示加载状态
 */
- (void)showActivityIndicatorWithIdentifier:(nonnull NSString *)identifier groupIdentifier:(nullable NSString *)group model:(BOOL)model message:(nullable NSString *)message;

/**
 显示一个操作成功的信息，显示一段时间后自动隐藏
 */
- (void)showSuccessStatus:(nullable NSString *)message;

/**
 显示一个错误提醒，一段时间后自动隐藏
 */
- (void)showErrorStatus:(nullable NSString *)message;

/**
 显示一个操作失败的错误消息，显示一段时间后自动隐藏
 */
- (void)alertError:(nullable NSError *)error title:(nullable NSString *)title;


@end
