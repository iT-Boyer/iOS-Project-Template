/*
 NSUserDefaults+MBDebug
 
 Copyright © 2018 RFUI.
 https://github.com/BB9z/iOS-Project-Template
 
 Apache License, Version 2.0
 http://www.apache.org/licenses/LICENSE-2.0
 */

#import <MBAppKit/MBUserDefaults.h>

/**
 调试工具配置项
 */
@interface NSUserDefaults (MBDebug)

/// 调试模式是否开启
@property BOOL _debugEnabled;

/// 接口请求 SSL 安全性最小化，便于抓包调试
@property BOOL _debugAPIAllowSSLDebug;

@end
