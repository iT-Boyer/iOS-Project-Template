/*
 MBDebugPrivate.h
 
 Copyright © 2018 RFUI.
 https://github.com/BB9z/iOS-Project-Template
 
 Apache License, Version 2.0
 http://www.apache.org/licenses/LICENSE-2.0
 
 MBDebug 私有头文件
 */

#import "ShortCuts.h"

#if DEBUG
#import <FLEX/FLEX.h>

// 默认私有头，暴露出来
@interface FLEXObjectExplorerFactory : NSObject

+ (UIViewController *)explorerViewControllerForObject:(id)object;

@end

#endif
