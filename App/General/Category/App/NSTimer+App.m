//
//  NSTimer+App.m
//  Feel
//
//  Created by ddhjy on 16/02/2017.
//  Copyright © 2017 Beijing ZhiYun ZhiYuan Technology Co., Ltd. All rights reserved.
//

#import "NSTimer+App.h"

@implementation NSTimer (App)

+ (NSTimer *)zy_scheduledTimerWithTimeInterval:(NSTimeInterval)interval repeats:(BOOL)repeats block:(void (^)(NSTimer *timer))block {
    return [self scheduledTimerWithTimeInterval:interval target:self selector:@selector(zy_blockInvoke:) userInfo:[block copy] repeats:repeats];
}

+ (void)zy_blockInvoke:(NSTimer *)timer {
    void (^block)(NSTimer *timer) = timer.userInfo;
    if(block) {
        block(timer);
    }
}

@end
