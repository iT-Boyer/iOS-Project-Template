//
//  MBTabControlButton.m
//  Feel
//
//  Created by ddhjy on 16/01/2017.
//  Copyright © 2017 Beijing ZhiYun ZhiYuan Technology Co., Ltd. All rights reserved.
//

#import "MBTabControlButton.h"

@implementation MBTabControlButton

- (void)afterInit {
    [super afterInit];
    [self setTitleColor:[self titleColorForState:UIControlStateNormal] forState:UIControlStateHighlighted];
    [self setTitleColor:[self titleColorForState:UIControlStateSelected] forState:UIControlStateSelected | UIControlStateHighlighted];
}

@end
