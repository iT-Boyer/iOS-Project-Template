//
//  MBAutoSearchBar.h
//  Very+
//
//  Created by BB9z on 10/1/14.
//  Copyright (c) 2014 Beijing ZhiYun ZhiYuan Information Technology Co., Ltd. All rights reserved.
//

#import "Common.h"

@class UISearchBarDelegateChain;

/**
 
 keywords 会去除前后的空格

 内部响应的代理事件：
 
 - 文字变化
 - 点击搜索时会立即强制（不比较是否与上次关键词一致）搜索
 - 点击取消时隐藏键盘
 */
@interface MBAutoSearchBar : UISearchBar <
    RFInitializing
>

@property (readonly, nonatomic) UISearchBarDelegateChain *trueDelegate;

@property (copy, nonatomic) void (^doSearch)(MBAutoSearchBar *searchBar, NSString *keywords);

/// 搜索中的关键字
@property (copy, nonatomic) NSString *searchingKeyword;

/// 搜索操作
/// 设置新的会自动取消旧的操作
@property (weak, nonatomic) NSOperation *searchOperation;

/// 默认 0.6 s
/// 设置为 0 关闭搜索
@property (nonatomic) IBInspectable float autoSearchTimeInterval;

/**
 允许自动搜索的关键字最短长度，小于该长度的不自动搜索
 */
@property (nonatomic) IBInspectable NSUInteger autoSearchMinimumLength;

/**
 不允许搜空
 */
@property (nonatomic) IBInspectable BOOL disallowEmptySearch;

- (void)doSearchWithKeyword:(NSString *)keyword force:(BOOL)force;

/**
 调用后尝试 autoSearchTimeInterval 后重新搜索
 */
- (void)setNeedsResearch;

/**
 点击取消时清空输入内容
 */
@property (nonatomic) IBInspectable BOOL clearTextWhenCancelButtonClicked;

@end
