//
//  MBEntityListDisplaying.h
//  Feel
//
//  Created by BB9z on 1/19/15.
//  Copyright (c) 2015 Beijing ZhiYun ZhiYuan Technology Co., Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@protocol MBEntityListDisplaying <NSObject>
@optional

- (id)listView;

- (void)refresh;

@end
