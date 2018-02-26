//
//  ZYTabBar.h
//  Very+
//
//  Created by BB9z on 8/16/14.
//  Copyright (c) 2014 Beijing ZhiYun ZhiYuan Information Technology Co., Ltd. All rights reserved.
//

#import "MBTabControl.h"
#import "ZYLayoutButton.h"

@class MBNotificationIndicator;


@interface ZYTabBar : MBTabControl
@property (nonatomic, nullable, weak) IBOutlet MBNotificationIndicator *moreIndicator;
@property (nonatomic, nullable, weak) IBOutlet MBNotificationIndicator *messageIndicator;
@end
