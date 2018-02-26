//
//  NSTimer+App.h
//  Feel
//
//  Created by ddhjy on 16/02/2017.
//  Copyright © 2017 Beijing ZhiYun ZhiYuan Technology Co., Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSTimer (App)

+ (NSTimer *)zy_scheduledTimerWithTimeInterval:(NSTimeInterval)interval repeats:(BOOL)repeats block:(void (^)(NSTimer *))block;

@end
