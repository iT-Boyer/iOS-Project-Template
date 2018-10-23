/*
 MBBadgeLabel
 
 Copyright © 2018 RFUI.
 https://github.com/BB9z/iOS-Project-Template

 Apache License, Version 2.0
 http://www.apache.org/licenses/LICENSE-2.0
 */
#import <RFInitializing/RFInitializing.h>
#import <RFKit/RFRuntime.h>

/**
 红点 label
 
 自动加圆角，调整大小和文字边距
 */
@interface MBBadgeLabel : UILabel

#if TARGET_INTERFACE_BUILDER
@property IBInspectable CGRect contentInset;
#else
/**
 文字边距
 
 默认 { 2, 4, 2, 4 }
 */
@property UIEdgeInsets contentInset;
#endif

/**
 设置显示数量
 */
- (void)updateCount:(long)count;

@end
