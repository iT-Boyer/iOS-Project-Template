/*!
 UIKit+App

 Copyright © 2016 Beijing ZhiYun ZhiYuan Technology Co., Ltd.
 https://github.com/BB9z/iOS-Project-Template
 
 Apache License, Version 2.0
 http://www.apache.org/licenses/LICENSE-2.0
 */

#import "UIKit+App.h"

@interface NSOperationQueue (App)

/**
 在队列上同步执行一个 block，但不会阻塞同步的队列
 */
- (void)performSynchronouslyWithBlock:(void (^_Nonnull)(void))block;

@end
