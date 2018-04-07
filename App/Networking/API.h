/*!
 API
 
 Copyright © 2018 RFUI. All rights reserved.
 Copyright © 2014-2016 Beijing ZhiYun ZhiYuan Information Technology Co., Ltd.
 https://github.com/RFUI/MBAppKit
 
 Apache License, Version 2.0
 http://www.apache.org/licenses/LICENSE-2.0
 */
#import "MBAPI.h"

extern NSString *__nonnull const APIErrorDomain;

/**
 API
 网络基础及接口封装

 如果有像UserID这种东西，让API来管理，不要在外面获取再传进来
 */
@interface API : MBAPI

#pragma mark - 具体业务


@end

/**
 返回一个空的 block，用于静默默认的错误弹窗
 */
void (^__nonnull APISlientFailureHandler(BOOL logError))(id __nullable, NSError *__nullable);


@interface UIImageView (App)

- (void)setImageWithURLString:(nullable NSString *)path placeholderImage:(nullable UIImage *)placeholder;

/**
 @param path 图片的 URL 地址，如果是相对地址，会跟 APIURLAssetsBase 做拼接
 @param placeholderImage 占位图，若为空，会把当前图片作为占位符
 */
- (void)setImageWithURLString:(nullable NSString *)path placeholderImage:(nullable UIImage *)placeholderImage completion:(nullable void (^)(void))completion;

@end

