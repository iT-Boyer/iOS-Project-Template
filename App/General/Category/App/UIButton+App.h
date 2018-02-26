/*!
 UIKit+App

 Copyright © 2016 Beijing ZhiYun ZhiYuan Technology Co., Ltd. All rights reserved.
 https://github.com/zhiyun168/Feel-iOS
 */

#import "UIKit+App.h"


@interface UIButton (App)
/// 当前标题
- (nullable NSString *)text;

/// 设置 normal 状态的标题
- (void)setText:(nullable NSString *)text;

/**
 设置便利的按钮点击事件
 */
@property (nonatomic, nullable, strong) void (^inlineTapActionBlock)(__kindof UIButton *__nonnull);

@end
