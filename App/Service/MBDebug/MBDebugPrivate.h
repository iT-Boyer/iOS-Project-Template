/*
 MBDebugPrivate.h
 
 Copyright © 2018 RFUI.
 https://github.com/BB9z/iOS-Project-Template
 
 The MIT License
 https://opensource.org/licenses/MIT
 
 MBDebug 私有头文件
 */

#import "ShortCuts.h"

#if __has_include("FLEX/FLEX.h")
#import <FLEX/FLEX.h>

#ifndef _FLEXObjectExplorerViewController_h
// 默认私有头，暴露出来
@interface FLEXObjectExplorerFactory : NSObject

+ (UIViewController *)explorerViewControllerForObject:(id)object;

@end
#endif

#endif
