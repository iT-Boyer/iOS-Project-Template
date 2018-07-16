/*!
 AccountEntity
 
 Copyright © 2018 RFUI. All rights reserved.
 https://github.com/RFUI/MBAppKit
 
 Apache License, Version 2.0
 http://www.apache.org/licenses/LICENSE-2.0
 */
#import "MBModel.h"

/**
 用户信息 model
 */
@interface AccountEntity : MBModel
#if MBUserStringUID
@property (nonnull) MBIdentifier uid;
#else
@property MBID uid;
#endif

/// 转移到其他对象上
@property (nullable) NSString *token;
@end
