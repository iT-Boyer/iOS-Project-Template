/*!
 UIKit+App

 Copyright © 2016 Beijing ZhiYun ZhiYuan Technology Co., Ltd. All rights reserved.
 https://github.com/zhiyun168/Feel-iOS
 */

#import "UIKit+App.h"

@interface NSOperationQueue (App)

/**
 在队列上同步执行一个 block，但不会阻塞同步的队列
 */
- (void)performSynchronouslyWithBlock:(void (^_Nonnull)(void))block;

@end
