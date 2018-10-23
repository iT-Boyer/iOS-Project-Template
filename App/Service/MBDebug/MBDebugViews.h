/*!
 MBDebugViews
 
 Copyright © 2018 RFUI. All rights reserved.
 Copyright © 2016 Beijing ZhiYun ZhiYuan Technology Co., Ltd. All rights reserved.
 https://github.com/RFUI/MBAppKit
 
 Apache License, Version 2.0
 http://www.apache.org/licenses/LICENSE-2.0
 */
#import <RFKit/RFRuntime.h>
#import <RFInitializing.h>

/**
 在 debug mode 下才会显示的 view
 */
@interface MBDebugContainerView : UIView
@end

/**
 在 debug mode 下才会显示的 scroll view
 */
@interface MBDebugContainerScrollView : UIScrollView
@end

#pragma mark - Window

@class RFWindow;

@interface MBDebugWindowButton : UIButton <
    RFInitializing
>
@property (nonatomic, strong) RFWindow *win;

+ (void)installToKeyWindow;
@end
