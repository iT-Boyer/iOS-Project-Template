/*
 UIButton+App

 Copyright © 2018 RFUI.
 Copyright © 2016 Beijing ZhiYun ZhiYuan Technology Co., Ltd.
 https://github.com/BB9z/iOS-Project-Template
 
 Apache License, Version 2.0
 http://www.apache.org/licenses/LICENSE-2.0
 */

#import "UIKit+App.h"


@interface UIButton (App)

/// 当前标题
- (nullable NSString *)text;

/// 设置 normal 状态的标题
- (void)setText:(nullable NSString *)text;

@end
