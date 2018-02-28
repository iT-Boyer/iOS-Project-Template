//
//  PBTest.m
//  project-framework
//
//  Created by BB9z on 24/10/2016.
//  Copyright © 2016 Beijing ZhiYun ZhiYuan Technology Co., Ltd. All rights reserved.
//

#import "样例.h"

@implementation PBTest

- (NSString *)hello {
#if DEBUG
    return @"hello debug";
#else
    return @"hello release";
#endif
}

@end
