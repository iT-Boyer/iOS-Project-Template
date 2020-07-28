/*
 UIKit+App
 
 Copyright © 2018, 2020 RFUI.
 Copyright © 2016-2017 Beijing ZhiYun ZhiYuan Technology Co., Ltd.
 Copyright © 2014 Chinamobo Co., Ltd.
 https://github.com/BB9z/iOS-Project-Template

 The MIT License
 https://opensource.org/licenses/MIT
 */

/**
 全局引用常用扩展
 */

#import <RFKit/RFKit.h>
#import <RFKit/NSDate+RFKit.h>
#import <RFKit/NSDateFormatter+RFKit.h>

#pragma mark -

#import "NSArray+App.h"
#import "NSString+App.h"
#import "NSURL+App.h"

#if !TARGET_OS_WATCH
#import "UICollectionView+App.h"
#import "UITableView+App.h"
#import "UITextField+App.h"
#import "UIViewController+App.h"

#import "UIImage+MBImageSet.h"
#endif // !TARGET_OS_WATCH

/**
 任何时候 view 都不要直接使用屏幕尺寸！
 任何时候 view 都不要直接使用屏幕尺寸！
 任何时候 view 都不要直接使用屏幕尺寸！

 第一，不要用代码写界面，难于维护。动不动弄个又臭又长的上千行代码，浪费其他人生命么？
 第二，用代码写界面也不是像你那样写的，一个 view 跟屏幕的尺寸屁的关系都没有。
 
 UIView 的 layoutSubviews、UIViewController 的 viewWillLayoutSubviews、viewDidLayoutSubviews
 是专门给你用来布局的，如果你既不用 AutoLayout，也不用 autoresizingMask，
 那么你就要负起更新布局的责任，在这些方法里根据父 view 的尺寸更新子 view 的位置。

 要用代码写就写好，不要写“init 完了取屏幕尺寸布局一下就了事”这种不负责任的代码。
 */
#define SCREEN_WIDTH 0
#define SCREEN_HEIGHT 0

/**
 禁止使用 NSLog(), 使用 dout 方法或 debug.h 中的方法。
 
 不是说完全不能用 NSLog，是生产环境不能用。生产环境用 NSLog 打印，
 一是会泄漏信息（NSLog 默认是输出到 stderr 的，会被系统日志保存的，
 可以被用户和第三方看到的），造成安全隐患；二是密集使用时可能影响性能。

 我们用 NSLog 就是为了调试用，这方面 dout 使用更方便，功能更多
 */
#if RFDEBUG
#define NSLog(...) RFAssert(false, @"禁止使用 NSLog()");
#endif
