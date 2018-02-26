//
//  MBSearchTextField.h
//  Feel
//
//  Created by jyq on 16/9/9.
//  Copyright © 2016年 Beijing ZhiYun ZhiYuan Technology Co., Ltd. All rights reserved.
//

#import "Common.h"

///使用textField作为搜索框时，可使用此类
@interface MBSearchTextField : UITextField<
    RFInitializing
>
@property (copy, nonatomic) void (^doSearch) (NSString *keyWords);

/// 默认 0.6 s,此处延时 1、为过滤输入过程中不需要的请求；2、为防止第一次搜索的分页结果覆盖第二次搜索的结果
/// 设置为 0 关闭搜索
@property (nonatomic) IBInspectable float autoSearchTimeInterval;

/**
 允许自动搜索的关键字最短长度，小于该长度的不自动搜索
 */
@property (nonatomic) IBInspectable NSUInteger autoSearchMinimumLength;

/// 传入APIName方便取消请求操作
@property (strong, nonatomic) IBInspectable NSString *APIName;

/**
 不允许搜空
 */
@property (nonatomic) IBInspectable BOOL disallowEmptySearch;

/**
 强制立即搜索
 */
- (void)doSearchforce;

@end
