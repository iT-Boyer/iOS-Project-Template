//
//  ZYTemplateImageView.h
//  Feel
//
//  Created by BB9z on 9/3/16.
//  Copyright © 2016 Beijing ZhiYun ZhiYuan Technology Co., Ltd. All rights reserved.
//

#import "Common.h"

/**
 设置的图像都会按 UIImageRenderingModeAlwaysTemplate 模式渲染的 image view
 */
@interface ZYTemplateImageView : UIImageView

/// 当 tintColor 和 ignoredTintColor 相同时，图片按原始效果渲染
@property (nonatomic, nullable, strong) IBInspectable UIColor *ignoredTintColor;

@end
