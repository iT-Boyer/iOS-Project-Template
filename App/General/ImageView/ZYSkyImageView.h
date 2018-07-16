/*!
 ZYSkyImageView
 
 Copyright © 2018 RFUI.
 Copyright © 2014-2015 Beijing ZhiYun ZhiYuan Technology Co., Ltd.
 https://github.com/BB9z/iOS-Project-Template
 
 Apache License, Version 2.0
 http://www.apache.org/licenses/LICENSE-2.0
 */
#import "ZYImageView.h"

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
