//
//  ZYNavigationOperation.h
//  Feel
//
//  Created by BB9z on 6/25/16.
//  Copyright © 2016 Beijing ZhiYun ZhiYuan Technology Co., Ltd. All rights reserved.
//

#import "Common.h"

@class PSTAlertController;

NS_ASSUME_NONNULL_BEGIN

/**
 用于组织具体的导航弹框操作的模型类。
 
 其中type属性设置弹框类型，必须有，其它属性则依据type值以及具体需求配置即可。
 具体的约束关系可以参考方法validateBeforeSchedule实现。
 */
@interface MBNavigationOperation : NSObject <
    RFInitializing
>

+ (nullable instancetype)operationWithConfiguration:(NS_NOESCAPE void (^ __nonnull)(__kindof MBNavigationOperation *__nonnull operation))configBlock;

@property BOOL animating; // 默认为NO，不提供动画

/// 用于限制导航操作只可在特定页面弹出
@property NSArray<Class> *topViewControllers;

/// 合法性检测，不同的的type需要不同的属性，在加入执行队列前要进行检测。
- (BOOL)validate;

/// 子类重写，子类属性的 description 描述
- (nullable NSString *)subClassPropertyDescription;

@end

NS_ASSUME_NONNULL_END

/**
 范用的、有自定义能力的 tips
 
 可用 target-action 或 block 模式，必设置一种
 */
@interface ZYCustomTipNavigationOperation : MBNavigationOperation
@property (nullable, weak) id target;
@property (nullable) SEL action;
@property (nullable) dispatch_block_t block;

/**
 必须设置，tip 如果显示出来必然涉及隐藏，导航调用该回调来隐藏 tips
 */
@property (nonatomic, nullable, copy) void (^dismissBlock)(ZYCustomTipNavigationOperation *__nonnull op, BOOL animated);

/// 默认 YES，导航切换 vc 时隐藏
@property BOOL shouldDismissWhenViewControllerChange;

/// tip 显示时是否可以阻挡其他非 tip 操作，默认 YES
@property BOOL canBlockOtherNonTipOperation;

/// 非 0 时，在 tips dismiss 或取消后尝试执行导航后续操作。默认 0
@property NSTimeInterval performNextNavigationOperationAfterDelay;
@end

/**
 ZYGestureHelpView 专用的 tips 导航操作
 
 target-action 或 block 在 tip 时显示时可做为通知使用
 
 如果以后要加其他参数什么的，要不改下 ZYGestureHelpView 的界面，把实例传进来得了
 */
@interface ZYGestureHelpNavigationOperation : ZYCustomTipNavigationOperation
@property (nonnull) NSString *message;

/**
 弹出前准备，block 返回是否应该展示。
 其中 block 的参数，
 - touchFromPoint 供指定指向哪里，默认 CGPointZero
 - shouldCancel 返回 YES 将从队列中移除不在执行
 */
@property (nonnull, copy) BOOL (^prepare)(CGPoint *__nonnull touchFromPoint, BOOL *__nonnull shouldCancel);

/// 建议在这里根据 canceled 参数设置标志位
/// 其中 canceled 为 NO 时，教学是展示过的了，为 YES 是条件不满足没有显示
@property (nullable, copy) void (^complation)(BOOL canceled);

@property (nullable, weak) UIView *gestureHelpView;
@end

/**
 弹出一个 UIAlertController
 */
@interface ZYAlertNavigationOperation : MBNavigationOperation
@property (nonnull) UIAlertController *alertController;
@end

/**
 在当前 vc 上弹出透明的 vc
 */
@interface ZYPresentNavigationOperation : MBNavigationOperation
@property (nonnull) UIViewController *displayViewController;
@end

