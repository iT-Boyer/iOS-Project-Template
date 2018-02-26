/*!
    MBTouchEffectButton
    v 0.1

    Copyright © 2014 Beijing ZhiYun ZhiYuan Information Technology Co., Ltd.
    https://github.com/BB9z/iOS-Project-Template

    Apache License, Version 2.0
    http://www.apache.org/licenses/LICENSE-2.0
 */
#import "MBButton.h"

/**
 按钮基础类，为按下实现特殊效果提供支持
 */
@interface MBTouchEffectButton : MBButton

/**
 禁用点按效果
 */
@property (nonatomic) IBInspectable BOOL touchEffectDisabled;

/**
 重写已实现按下效果
 */
- (void)touchDownEffect;

/**
 重写已实现手势抬起恢复效果
 */
- (void)touchUpEffect;

@end
