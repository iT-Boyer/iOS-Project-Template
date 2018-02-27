/*!
    APUserInfo

    Copyright © 2013-2014 Chinamobo Co., Ltd.
    https://github.com/Chinamobo/iOS-Project-Template

    Apache License, Version 2.0
    http://www.apache.org/licenses/LICENSE-2.0
 */
#import "MBModel.h"

/**
 用户信息 model
 */
@interface APUserInfo : MBModel
@property (nonatomic) MBID uid;

/// 转移到其他对象上
@property (nonatomic, nullable, strong) NSString *token;
@end
