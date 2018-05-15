/*!
 UIScrollView+IBScrollsToTop
 
 Copyright © 2018 RFUI.
 https://github.com/RFUI/MBAppKit
 
 Apache License, Version 2.0
 http://www.apache.org/licenses/LICENSE-2.0
 */

#import "UIKit+IBInspectable.h"

/**
 Stroyboard 中没提供这项的开关
 */
@interface UIScrollView (IBScrollsToTop)
@property (nonatomic) IBInspectable BOOL scrollsToTop;
@end
