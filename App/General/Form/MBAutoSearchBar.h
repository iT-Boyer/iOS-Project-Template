/*!
    MBAutoSearchBar
    v 0.1

    Copyright © 2014 Beijing ZhiYun ZhiYuan Technology Co., Ltd.
    https://github.com/Chinamobo/iOS-Project-Template

    Apache License, Version 2.0
    http://www.apache.org/licenses/LICENSE-2.0
 */
#import "RFUI.h"

@class UISearchBarDelegateChain;

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
@property (assign, nonatomic) IBInspectable float autoSearchTimeInterval;

/**
 不允许搜空
 */
@property (assign, nonatomic) IBInspectable BOOL disallowEmptySearch;

- (void)doSearchWithKeyword:(NSString *)keyword force:(BOOL)force;

@end
