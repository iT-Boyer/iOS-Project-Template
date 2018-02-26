/*!
    MBRefreshFooterView
    v 0.2

    Copyright © 2015 Beijing ZhiYun ZhiYuan Information Technology Co., Ltd.
    Copyright © 2014 Chinamobo Co., Ltd.
    https://github.com/Chinamobo/iOS-Project-Template

    Apache License, Version 2.0
    http://www.apache.org/licenses/LICENSE-2.0
 */

#import "Common.h"
#import "RFTableViewPullToFetchPlugin.h"

@interface MBRefreshFooterView : UIView <
    RFInitializing
>
@property (weak, nonatomic) IBOutlet UILabel *emptyLabel;
@property (weak, nonatomic) IBOutlet UILabel *endLabel;
@property (weak, nonatomic) IBOutlet UILabel *textLabel;

/**
 外部的空内容指示视图，如果设置 MBRefreshFooterView 会根据自身 empty 属性变化设置该视图的显隐
 */
@property (weak, nonatomic) IBOutlet UIView *outerEmptyView;

/**
 列表内容为空。
 
 置为 YES 将显示 emptyLabel 的内容
 */
@property (nonatomic) BOOL empty;

@property (weak, nonatomic) IBOutlet UIImageView *backgroundImageView;

@property (nonatomic) RFPullToFetchIndicatorStatus status;
- (void)updateStatus:(RFPullToFetchIndicatorStatus)status distance:(CGFloat)distance control:(RFTableViewPullToFetchPlugin *)control;

@end
