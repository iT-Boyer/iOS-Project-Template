/*
 UIImageView+MBRenderingMode
 
 Copyright © 2018 RFUI.
 Copyright © 2015 Beijing ZhiYun ZhiYuan Technology Co., Ltd.
 https://github.com/BB9z/iOS-Project-Template
 
 The MIT License
 https://opensource.org/licenses/MIT
 */
#import <RFKit/RFRuntime.h>

/**
 从 iOS 7 开始，系统就支持将图片按照给的颜色渲染，
 但即使 iOS 9，image view 对这个过程的处理仍与预期不符。iOS 11，刷新一下后颜色才能变更。
 
 iOS 9.2 SDK 下，具体表现是：
 
 * iOS 7，image view 的 tintColor 完全不影响图片渲染
 * iOS 8, 9，设置 renderingMode 为 UIImageRenderingModeAlwaysTemplate 的图片仅当未设置 image view 的 tintColor 时会被上色
 * iOS 8，9，tintColor 需要设置一个跟上次不同的色值才会有效，且 nib 中设置的颜色不起作用
 */
@interface UIImageView (MBRenderingMode)

// @MBDependency:1
/**
 设置时强制将图片按 UIImageRenderingModeAlwaysTemplate 方式渲染
 
 不会影响以后设置 image 和其它相关属性
 */
@property (nonatomic) IBInspectable BOOL renderingAsTemplate API_AVAILABLE(ios(8.0), tvos(9.0));
@end
