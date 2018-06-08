/*!
 MBCollapsibleView
 
 Copyright © 2018 RFUI.
 Copyright © 2014-2016 Beijing ZhiYun ZhiYuan Technology Co., Ltd.
 https://github.com/BB9z/iOS-Project-Template
 
 Apache License, Version 2.0
 http://www.apache.org/licenses/LICENSE-2.0
 */

#import <UIKit/UIKit.h>
#import <RFInitializing/RFInitializing.h>

/**
 折叠区域，通过控制 expand 属性调整尺寸

 Collapsible view 的原理是通过修改 intrinsicContentSize 控制展开折叠的，
 所以要设置内部元素的约束要注意优先级不要大于容器尺寸的优先级，也不要添加容器折叠方向的尺寸约束，否则折叠可能会无法正确工作。
 
 折叠时的尺寸就看 contractedHeight 或 contractedWidth 的属性，默认是 0。
 
 展开量有两种模式，一种是通过 expandedHeight 或 expandedWidth 属性控制；
 另一种是通过设置约束的方式，让容器内部的元素撑起容器，这当容器内容是动态变化时很有用，设置 useIntrinsicExpandSize 以激活这个特性。

 推荐的 IB 设置方式：
 
 如果是 useIntrinsicExpandSize 模式，先正常设置内部元素的约束就好，最后把折叠方向的一个约束分量设为低优先级，建议 200 左右或更低。
 
 因为一般在 IB 中 collapsible view 是展开的以便查看编辑，如果展开量固定的话需要想办法把容器撑起来，不然默认尺寸是 0，有两种方式：
 一种是设置一个尺寸约束但置为运行时移除，推荐；
 另一种是设置 size tab 中的 intrinsic size 为 placeholder 模式并指定尺寸。

 其他属性按需设置。用代码控制 expand 显隐。
 */
@interface MBCollapsibleView : UIView <
    RFInitializing
>

/// 默认 YES
@property (nonatomic) IBInspectable BOOL expand;

/**
 控制折叠是水平方向还是竖直方向，默认 NO——竖直方向
 */
@property (nonatomic) IBInspectable BOOL horizontal;

/**
 折叠起来的约束量，默认 0
 */
@property IBInspectable CGFloat contractedHeight;
@property IBInspectable CGFloat contractedWidth;

/**
 展开的约束量

 默认 UIViewNoIntrinsicMetric
 */
@property IBInspectable CGFloat expandedHeight;
@property IBInspectable CGFloat expandedWidth;

/**
 展开时使用 Auto Layout 自动尺寸
 */
@property IBInspectable BOOL useIntrinsicExpandSize;

/**
 折叠起来时同时设置隐藏，默认 NO
 */
@property IBInspectable BOOL hiddenWhenContracted;

@end
