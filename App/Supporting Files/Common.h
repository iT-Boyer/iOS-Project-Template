/**
 公共头文件
 
 用来替代 Prefix.pch，pch 的优点是不用每个文件都引入，
 但缺点是一但修改包含的头，需要重新编译整个项目。
 
 在实践过程中，这个缺点不足矣弥补免除手动引入的好处
 */

#pragma once

#import <Availability.h>

#ifndef __IPHONE_7_0
#warning "This project uses features only available in iOS SDK 7.0 and later."
#warning "项目编译需要 iOS 7 SDK"
#endif

/// MBBuildConfiguration 是个字符串，用于区分当前版本是哪种配置编译的
#ifndef MBBuildConfiguration
#define MBBuildConfiguration ""
#endif

#import "RFUI.h"
#import "ShortCuts.h"
// @TODO
//#import "ZYNavigationController.h"

#import "UIKit+App.h"
#import "MBGeneral.h"
#import "ZYErrorCode.h"
