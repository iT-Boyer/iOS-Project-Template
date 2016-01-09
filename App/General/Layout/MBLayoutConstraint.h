/*!
    MBButton
    v 0.5

    Copyright © 2014 Beijing ZhiYun ZhiYuan Information Technology Co., Ltd.
    https://github.com/Chinamobo/iOS-Project-Template

    Apache License, Version 2.0
    http://www.apache.org/licenses/LICENSE-2.0
 */
#import <UIKit/UIKit.h>

/**
 增加了折叠展开支持
 */
@interface MBLayoutConstraint : NSLayoutConstraint

@property (nonatomic) IBInspectable BOOL expand;
- (void)setExpand:(BOOL)expand animated:(BOOL)animated;

/**
 折叠起来的约束量
 */
@property (nonatomic) IBInspectable CGFloat contractedConstant;

/**
 展开的约束量

 如未设置（为0），将在 awakeFromNib 时设置为当前约束量
 */
@property (nonatomic) IBInspectable CGFloat expandedConstant;
@end
