/*!
    API
    v 2.0

    Copyright © 2014 Beijing ZhiYun ZhiYuan Information Technology Co., Ltd.
    Copyright © 2013-2014 Chinamobo Co., Ltd.
    https://github.com/Chinamobo/iOS-Project-Template

    Apache License, Version 2.0
    http://www.apache.org/licenses/LICENSE-2.0
 */
#import "MBAPI.h"

extern NSString *const APIErrorDomain;

/**
 API
 网络基础及接口封装

 如果有像UserID这种东西，让API来管理，不要在外面获取再传进来
 */
@interface API : MBAPI

#pragma mark - 具体业务


@end


@interface UIImageView (App)

- (void)setImageWithURLString:(NSString *)path placeholderImage:(UIImage *)placeholder;

/**
 @param path 图片的 URL 地址，如果是相对地址，会跟 APIURLAssetsBase 做拼接
 @param placeholderImage 占位图，若为空，会把当前图片作为占位符
 */
- (void)setImageWithURLString:(NSString *)path placeholderImage:(UIImage *)placeholderImage completion:(void (^)(void))completion;

@end

