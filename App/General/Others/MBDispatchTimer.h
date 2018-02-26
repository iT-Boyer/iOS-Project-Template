//
//  MBDispatchTimer.h
//  Feel
//
//  Created by BB9z on 5/4/16.
//  Copyright © 2016 Beijing ZhiYun ZhiYuan Technology Co., Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 使用 dispatch source 延迟执行（并可以取消）一段代码
 
 存在的意义是解决 NSRunLoop 在后台不能触发即时的问题，NSTimer 和 performSelector:afterDelay: 都是基于 NSRunLoop 的。
 */
@interface MBDispatchTimer : NSObject

/**

 @param queue 为空使用 main queue
 
 @return timer 可能创建失败，返回空
 */
+ (nullable instancetype)scheduledTimerWithTimeInterval:(NSTimeInterval)interval block:(nonnull dispatch_block_t)block onQueue:(nullable dispatch_queue_t)queue;

- (void)cancel;

@end
