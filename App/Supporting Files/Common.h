/**
 公共头文件
 
 用来替代 Prefix.pch，pch 的优点是不用每个文件都引入，
 但缺点是一但修改包含的头，需要重新编译整个项目。
 
 在实践过程中，这个缺点不足矣弥补免除手动引入的好处
 */

#pragma once

#import <Availability.h>

/// MBBuildConfiguration 是个字符串，用于区分当前版本是哪种配置编译的
#ifndef MBBuildConfiguration
#define MBBuildConfiguration ""
#endif

#import <MBAppKit.h>
#import "ShortCuts.h"
#import "MBNavigationController.h"

#import "UIKit+App.h"
