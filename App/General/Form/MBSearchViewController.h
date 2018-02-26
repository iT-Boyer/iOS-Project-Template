//
//  MBSearchViewController.h
//  Feel
//
//  Created by BB9z on 12/1/14.
//  Copyright (c) 2014 Beijing ZhiYun ZhiYuan Technology Co., Ltd. All rights reserved.
//

#import "Common.h"
#import "MBAutoSearchBar.h"

/**
 通用沉浸式搜索界面
 
 用来替代 UISearchDisplayController
 */
@interface MBSearchViewController : UIViewController <
    UISearchBarDelegate
>
@property (weak, nonatomic) IBOutlet MBAutoSearchBar *searchBar;
@property (weak, nonatomic) IBOutlet UIView *container;
@property IBInspectable BOOL focusSearchBarWhenAppear;

@property BOOL hasViewAppeared;

/**
 延迟的 view 设置
 
 默认什么也不做
 */
- (void)setupAfterViewAppear;
@end


