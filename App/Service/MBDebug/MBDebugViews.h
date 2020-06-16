/*
 MBDebugViews
 
 Copyright © 2018 RFUI.
 Copyright © 2016 Beijing ZhiYun ZhiYuan Technology Co., Ltd.
 https://github.com/BB9z/iOS-Project-Template
 
 The MIT License
 https://opensource.org/licenses/MIT
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
