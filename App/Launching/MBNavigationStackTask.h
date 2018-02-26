//
//  MBNavigationStackTask.h
//  Feel
//
//  Created by BB9z on 23/11/2016.
//  Copyright © 2016 Beijing ZhiYun ZhiYuan Technology Co., Ltd. All rights reserved.
//

#import "Common.h"

typedef NS_ENUM(int, MBNavigationStackTaskType) {
    MBNavigationStackTaskNoType = 0,
    MBNavigationStackTaskPushType,
    MBNavigationStackTaskPopType,
    MBNavigationStackTaskSetType
};

/**
 导航暂存的堆栈操作
 */
@interface MBNavigationStackTask : NSObject
@property MBNavigationStackTaskType type;
/// push 时是要推出的 vc，pop 时是 popTo 的 vc
@property (nullable) UIViewController *viewController;
/// setVC 时的 vc 们
@property (nullable) NSArray<UIViewController *> *viewControllers;
@property BOOL animated;

+ (nonnull instancetype)pushTaskWithViewController:(nonnull UIViewController *)viewController animated:(BOOL)animated;
+ (nonnull instancetype)popTaskAnimated:(BOOL)animated;
+ (nonnull instancetype)popToTaskWithViewController:(nonnull UIViewController *)viewController animated:(BOOL)animated;
+ (nonnull instancetype)setTaskWithViewControllers:(nonnull NSArray<UIViewController *> *)viewControllers animated:(BOOL)animated;


/**
 返回堆栈操作的结果

 @param tasks 堆栈操作
 @param viewControllers 要应用操作的起始堆栈
 @param shouldAnimated 是否需要动画执行
 @return 参数无效或没有有效的变更返回 nil
 */
+ (nullable NSArray<UIViewController *> *)processedStackWithTasks:(nullable NSArray<MBNavigationStackTask *> *)tasks stackBefore:(nullable NSArray<UIViewController *> *)viewControllers shouldAnimated:(nullable BOOL *)shouldAnimated;

@end
