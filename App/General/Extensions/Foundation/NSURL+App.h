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

// @MBDependency:2
- (BOOL)isHTTPURL;

@end

/*
 沙箱内 URL 每次启动变化解决，参考
 https://github.com/BB9z/iOS-Project-Template/blob/4.1/App/General/Extensions/Foundation/NSURL%2BApp.h#L17-L41
 */
