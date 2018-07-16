/*!
 MBSearchTextField
 
 Copyright © 2018 RFUI. All rights reserved.
 Copyright © 2016 Beijing ZhiYun ZhiYuan Technology Co., Ltd.
 https://github.com/RFUI/MBAppKit
 
 Apache License, Version 2.0
 http://www.apache.org/licenses/LICENSE-2.0
 */
#import <RFKit/RFRuntime.h>
#import <RFInitializing/RFInitializing.h>

/**
 
 */
@interface MBSearchTextField : UITextField <
    RFInitializing
>

/**
 默认 0.6 s，此处延时
 1. 为过滤输入过程中不需要的请求
 2. 为防止第一次搜索的分页结果覆盖第二次搜索的结果
 
 设置为 0 关闭搜索，初始化后变更可能不生效
 */
@property IBInspectable double autoSearchTimeInterval;

/**
 允许自动搜索的关键字最短长度，小于该长度的不自动搜索
 */
@property IBInspectable NSUInteger autoSearchMinimumLength;

/**
 非空时会自动取消相应的请求
 */
@property (nullable) IBInspectable NSString *APIName;

/**
 不允许搜空
 */
@property IBInspectable BOOL disallowEmptySearch;

#pragma mark -

@property (nullable) void (^doSearch)(NSString *__nullable keyWords);

/**
 强制立即搜索
 */
- (void)doSearchforce;

/**
 外部搜索结束后需要手动设置为 NO
 */
@property (nonatomic) BOOL isSearching;

@end
