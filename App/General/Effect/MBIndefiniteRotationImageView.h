/*
 MBIndefiniteRotationImageView
 
 Copyright © 2018 RFUI.
 https://github.com/BB9z/iOS-Project-Template
 
 Apache License, Version 2.0
 http://www.apache.org/licenses/LICENSE-2.0
 */

#import <RFKit/RFRuntime.h>

// @MBDependency:2
/**
 无限旋转的 image view
 */
@interface MBIndefiniteRotationImageView : UIImageView

/// 可以控制动画停止
@property (nonatomic) IBInspectable BOOL stopAnimation;

#if TARGET_INTERFACE_BUILDER
@property IBInspectable double rotateDuration;
#else
/// 动画时间，动画已开始设置不会自动更新动画，停止后再开启才会生效
@property NSTimeInterval rotateDuration;
#endif

@end
