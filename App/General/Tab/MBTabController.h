//
//  MBTabController.h
//  Feel
//
//  Created by BB9z on 6/5/15.
//  Copyright (c) 2015 Beijing ZhiYun ZhiYuan Technology Co., Ltd. All rights reserved.
//

#import "RFPageTabController.h"
#import "MBGeneralListDisplaying.h"
#import "MBTabControl.h"

@interface MBTabController : RFPageTabController <
    RFTabControllerDelegate,
    MBGeneralListDisplaying
>
@property (weak, nonatomic) IBOutlet MBTabControl *tabControl;

/**
 tab 切换时调用这个方法更新列表设置和页面统计
 */
- (void)updateListWhenSelectedIndexChanged;

/**
 手势驱动的切换，和 tabControl 响应的事件会调用下面两个方法，手动调用 setSelectedIndex:animated:completion: 则不会

 will did 可以保证成对出现，否则可能是个 bug
 
 默认实现都是空
 */
- (void)willSelectViewController:(UIViewController *)viewController atIndex:(NSUInteger)index;
- (void)didSelectViewController:(UIViewController *)viewController atIndex:(NSUInteger)index;

///标识是否是点击按钮驱动tab切换,default = NO;
@property (nonatomic) BOOL isTapTabControlSwichPage;

@end