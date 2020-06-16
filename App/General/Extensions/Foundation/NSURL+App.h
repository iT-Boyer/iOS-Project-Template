/*
 NSURL+App

 Copyright © 2018 RFUI.
 Copyright © 2016 Beijing ZhiYun ZhiYuan Technology Co., Ltd.
 https://github.com/BB9z/iOS-Project-Template
 
 The MIT License
 https://opensource.org/licenses/MIT
 */

#import "UIKit+App.h"

@interface NSURL (App)

// @MBDependency:1 向后兼容保留，请改用 URL 的 bookmark 机制
/**
 Data protection 机制导致应用每次启动路径发生变化，导致之前保存的 URL 失效
 
 这个方法尝试相对于沙箱路径重建新的 URL，如果原始 URL 不是应用沙箱内的 URL，返回原始 URL

 @code

 NSString *homePath = NSHomeDirectory();
 // Assume "/Something/Application/B383551F-41C1-4E3D-8EA9-8D76E4AFA919"

 NSURL *test;
 test = [NSURL fileURLWithPath:homePath];
 [test URLByResolvingApplicationDirectoryChange];
 // file://Something/Application/B383551F-41C1-4E3D-8EA9-8D76E4AFA919

 test = [NSURL URLWithString:@"file:///Foo/bar"];
 [test URLByResolvingApplicationDirectoryChange];
 // file:///Foo/bar

 test = [NSURL URLWithString:@"file://Something/Application/12345678-1234-1234-1234-123456789ABC/path.tmp"];
 // file://Something/Application/B383551F-41C1-4E3D-8EA9-8D76E4AFA919/path.tmp

 @endcode
 */
- (nonnull NSURL *)URLByResolvingApplicationDirectoryChange;

// @MBDependency:2
- (BOOL)isHTTPURL;

@end
