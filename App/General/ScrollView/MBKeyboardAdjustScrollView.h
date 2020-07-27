/*
 MBKeyboardAdjustScrollView

 Copyright © 2020 RFUI.
 https://github.com/BB9z/iOS-Project-Template

 The MIT License
 https://opensource.org/licenses/MIT
 */

#import <RFKit/RFRuntime.h>

// @MBDependency:2
/**
 随键盘调整 content inset

 保证键盘出现时所有内容滚动可见（底部不会被键盘遮住）
 如果获取焦点的输入框在 scroll view 中（无论层级），尝试以最好的效果（考虑选中范围，视图大小）滚动可见
 */
@interface MBKeyboardAdjustScrollView : UIScrollView
@end
