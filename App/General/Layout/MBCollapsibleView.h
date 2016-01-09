/*!
    MBCollapsibleView
    v 0.3

    Copyright © 2014 Beijing ZhiYun ZhiYuan Technology Co., Ltd.
    https://github.com/BB9z/iOS-Project-Template

    Apache License, Version 2.0
    http://www.apache.org/licenses/LICENSE-2.0
 */
#import "RFUI.h"

/**
 折叠区域
 
 推荐使用方式：
 
 Stotyboard 中 Intrinsic size 用 Placeholder 方式定义，
 其他属性可选设置。用代码控制 expand 显隐。
 */
@interface MBCollapsibleView : UIView <
    RFInitializing
>

@property (nonatomic) IBInspectable BOOL expand;

/**
 折叠是水平方向
 */
@property (assign, nonatomic) IBInspectable BOOL horizontal;

/**
 折叠起来的约束量，默认 0
 */
@property IBInspectable CGFloat contractedHeight;
@property IBInspectable CGFloat contractedWidth;

/**
 展开的约束量

 如未设置（为0），将在 awakeFromNib 时设置为当前约束量
 */
@property IBInspectable CGFloat expandedHeight;
@property IBInspectable CGFloat expandedWidth;

/**
 展开时使用自动高度
 */
@property IBInspectable BOOL useIntrinsicExpandSize;

/**
 折叠起来时同时设置隐藏，默认 NO
 */
@property IBInspectable BOOL hiddenWhenContracted;

@end
