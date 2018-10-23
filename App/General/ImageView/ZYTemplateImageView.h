/*
 ZYTemplateImageView
 
 Copyright © 2018 RFUI.
 Copyright © 2016-2017 Beijing ZhiYun ZhiYuan Technology Co., Ltd.
 https://github.com/BB9z/iOS-Project-Template
 
 Apache License, Version 2.0
 http://www.apache.org/licenses/LICENSE-2.0
 */
#import <RFKit/RFRuntime.h>

/**
 设置的图像都会按 UIImageRenderingModeAlwaysTemplate 模式渲染的 image view
 */
@interface ZYTemplateImageView : UIImageView

/// 当 tintColor 和 ignoredTintColor 相同时，图片按原始效果渲染
@property (nullable, nonatomic) IBInspectable UIColor *ignoredTintColor;

@end
