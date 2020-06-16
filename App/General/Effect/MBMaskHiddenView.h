/*!
MBMaskHiddenView

Copyright © 2020 RFUI.
https://github.com/BB9z/iOS-Project-Template

The MIT License
https://opensource.org/licenses/MIT
*/

#import <UIKit/UIKit.h>

// @MBDependency:2
/**
 显示隐藏时执行 mask 遮罩动画，快速频繁调用有着良好的处理
 */
@interface MBMaskHiddenView : UIView

- (void)setHidden:(BOOL)hidden animated:(BOOL)animated;

@end
