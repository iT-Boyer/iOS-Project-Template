//
//  MBKeyboardInputContainer.h
//  Feel
//
//  Created by BB9z on 11/25/14.
//  Copyright (c) 2014 Beijing ZhiYun ZhiYuan Information Technology Co., Ltd. All rights reserved.
//

#import "Common.h"

/**
 一般是界面底部的一个容器，键盘弹出来跟着向上浮动，键盘收起又回落了
 
 使用：
 - 连接 bottomMargin

 */
@interface MBKeyboardFloatContainer : UIView <
    RFInitializing
>

/**
 键盘弹出时会设置该约束为键盘高度，收起时设置成 0
 */
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *keyboardLayoutConstraint;

//键盘弹出时的约束常量
@property (nonatomic) IBInspectable CGFloat keyboardLayoutOriginalConstraint;
/**
 用以调节 bottomMargin 约束的偏移量
 */
@property (nonatomic) IBInspectable CGFloat offsetAdjust;

/**
 弹出键盘时指定蒙版容器
 */
@property (nonatomic, weak) IBOutlet UIView *tapToDismissContainer;

/**
 键盘事件响应，重写应调用 super
 */
- (void)keyboardWillShow:(NSNotification *)note;
- (void)keyboardWillHide:(NSNotification *)note;

@end
