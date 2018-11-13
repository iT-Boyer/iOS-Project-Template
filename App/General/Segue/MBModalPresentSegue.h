/*
 MBModalPresentSegue
 
 Copyright © 2018 RFUI.
 Copyright © 2014-2016 Beijing ZhiYun ZhiYuan Technology Co., Ltd.
 Copyright © 2014 Chinamobo Co., Ltd.
 https://github.com/BB9z/iOS-Project-Template
 
 Apache License, Version 2.0
 http://www.apache.org/licenses/LICENSE-2.0
 */
#import <RFSegue/RFSegue.h>

// @MBDependency:4
/**
 弹出新的视图，与 view controller 内建的弹出方式不同之处在于不会隐藏当前视图，新视图不是加在当前视图的 view 中的，而是尽可能加在根视图中，会覆盖导航条
 
 destinationViewController 需要符合 MBModalPresentSegueDelegate 协议
 */
@interface MBModalPresentSegue : RFSegue

@end

// @MBDependency:4
/**
 从弹出层 push 到其他视图需使用本 segue，否则可能会导致布局问题，已知的是返回后，隐藏导航栏视图布局不会上移
 */
@interface MBModalPresentPushSegue : UIStoryboardSegue
@end

@protocol MBModalPresentSegueDelegate <NSObject>
@required
- (void)setViewHidden:(BOOL)hidden animated:(BOOL)animated completion:(nullable void (^)(void))completion;

@end

@interface MBModalPresentViewController : UIViewController <
    MBModalPresentSegueDelegate
>

@property (nonatomic) UIAlertControllerStyle preferredStyle;

/**
 从其他视图弹出
 */
- (void)presentFromViewController:(nullable UIViewController *)parentViewController animated:(BOOL)animated completion:(nullable void (^)(void))completion;

@property (weak, nullable, nonatomic) IBOutlet UIView *maskView;
@property (weak, nullable, nonatomic) IBOutlet UIView *containerView;

/// 子类重写以改变动效
- (void)setViewHidden:(BOOL)hidden animated:(BOOL)animated completion:(nullable void (^)(void))completion;

/// MBModalPresent 的标准 dismiss 方法
- (void)dismissAnimated:(BOOL)flag completion:(nullable void (^)(void))completion NS_SWIFT_UNAVAILABLE("跟 UIKit 的 dismissViewControllerAnimated:completion: 重名了");

/// 被重写的系统方法，只 dismiss 自身
- (void)dismissViewControllerAnimated:(BOOL)flag completion:(nullable void (^)(void))completion;

- (IBAction)dismiss:(nullable UIButton *)sender;

@end
