//
//  ZYSkyImageView.h
//  Very+
//
//  Created by BB9z on 10/12/14.
//  Copyright (c) 2014 Beijing ZhiYun ZhiYuan Information Technology Co., Ltd. All rights reserved.
//

#import "CommonUI.h"

/**
 内容可以跟着一个 scrollView 同时滚动的 image view
 */
@interface ZYSkyImageView : ZYImageView <
    RFInitializing
>
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;

@property (nonatomic) IBInspectable CGFloat offsetAdjust;
@property (nonatomic) IBInspectable BOOL resizeTowardsTop;
@end
