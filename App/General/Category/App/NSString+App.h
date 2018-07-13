/*!
 UIKit+App

 Copyright © 2016 Beijing ZhiYun ZhiYuan Technology Co., Ltd.
 https://github.com/BB9z/iOS-Project-Template
 
 Apache License, Version 2.0
 http://www.apache.org/licenses/LICENSE-2.0
 */

#import "UIKit+App.h"

@interface NSString (App)

/// email 格式检查
- (BOOL)isValidEmail;

/// 是否是大陆手机手机号
- (BOOL)isValidPhoneNumber;

/// 字符串硬换行的行数
- (NSUInteger)rf_numberOfHardLineBreaks;

- (long)longValue;
- (long long)unsignedLongLongValue;

/**
 判断给定新版本是否是更新的
 
 @param latestVersion 新版本
 @param currentversion 当前版本，一定不能为空
 */
+ (BOOL)isNewVersion:(nullable NSString *)latestVersion currentversion:(nonnull NSString *)currentversion;

@end
