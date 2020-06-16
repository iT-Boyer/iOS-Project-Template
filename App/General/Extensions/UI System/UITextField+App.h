/*
 UITextField+App

 Copyright © 2018 RFUI.
 Copyright © 2016 Beijing ZhiYun ZhiYuan Technology Co., Ltd.
 https://github.com/BB9z/iOS-Project-Template
 
 The MIT License
 https://opensource.org/licenses/MIT
 */

#import "UIKit+App.h"

@interface UITextField (App)

// @MBDependency:3
- (nullable NSString *)trimedText;

// @MBDependency:2
// @MBShouldMergeIntoLib
- (NSRange)selectedRange;

@end
