

#pragma once

#import <Foundation/Foundation.h>

/**
 定义应用共享错误码

 20000-30000
 
 一共五位数，用途如下
 
 |     1    |     2    |     3    |     4    |       5      |
 | App 空间 | 错误大类 | 错误大类 | 何种错误 | 错误处理区分 |

 @warning 定好的数字不应随意调整
 */
typedef NS_ENUM(NSInteger, ZYErrorCode) {

    //-- 数据错误 (1XXX)
    /// 数据格式错误，无法处理，需要扔掉
    ZYErrorDataInvaild              = 21010,

    /// 数据不支持，提示新版本
    ZYErrorDataNotSupport           = 21020,

    /// 因数据来源问题，数据不可用
    ZYErrorDataNotAvailable         = 21100,
    
    /// 对象找不到
    ZYErrorObjectNotFound           = 21400,

    //-- 操作错误 (2XXX)
    /// 重复操作，提示用户稍候再试
    ZYErrorOperationRepeat          = 22010,

    /// 操作取消
    ZYErrorOperationCanceled        = 22020,

    /// 网络原因操作失败
    ZYErrorOperationNetworkFail     = 22100,

    //-- 特性错误 (3xxx)
    /// 特性不可用，因为需要更高系统版本
    ZYErrorOSRequiredHigher         = 23110,

    /// 特性不可用，因为设备特性缺失
    ZYErrorLackDeviceCapability     = 23210,

    //-- 权限错误 (4xxx)
    /// 权限被禁用
    ZYErrorAuthorizationDenied      = 24100,

    /// 未授权
    ZYErrorAuthorizationNotDetermined = 24200,

    //-- 文件错误 (5xxx)
    /// 无效的路径
    ZYErrorPathInvaild              = 25010,

    /// 文件不存在
    ZYErrorFileNotExist             = 25300,

    //-- 其他错误 (8xxx)
    /// 时钟错误
    ZYErrorClockIncorrect           = 28100,

    //-- 意外的错误 (9xxx)
    /// 未知错误
    ZYErrorUnknow                   = 29000,

    /// 未捕获的代码异常
    ZYErrorUncaughtException        = 29100,
};

/// 应用代码的 error domain
extern NSString *const ZYErrorDomain;
