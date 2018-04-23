/*!
 UIKit+App

 Copyright © 2016 Beijing ZhiYun ZhiYuan Technology Co., Ltd. All rights reserved.
 https://github.com/zhiyun168/Feel-iOS
 */

#import "UIKit+App.h"

@interface NSObject (App)

/// 类名字符串，Swift 类名只保留 . 最后的部分
@property (class, nonnull, readonly) NSString *className;

/// 类名字符串
@property (nonnull, readonly) NSString *className;

@end

/**
 比较两个对象，两个对象都是 nil 认为是相同的，而直接用 isEqual: 方法会返回 NO
 */
BOOL MBObjectIsEquail(id __nullable a, id __nullable b);
