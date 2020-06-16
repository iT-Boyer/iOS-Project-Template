/*
 UIScrollView+IBScrollsToTop
 
 Copyright © 2018 RFUI.
 https://github.com/BB9z/iOS-Project-Template
 
 The MIT License
 https://opensource.org/licenses/MIT
 */

#import "UIKit+IBInspectable.h"

/**
 Stroyboard 中没提供这项的开关
 */
@interface UIScrollView (IBScrollsToTop)
@property (nonatomic) IBInspectable BOOL scrollsToTop;
@end
