
#import "MBNavigationStackTask.h"

@implementation MBNavigationStackTask

+ (instancetype)pushTaskWithViewController:(UIViewController *)viewController animated:(BOOL)animated {
    MBNavigationStackTask *t = [MBNavigationStackTask new];
    t.type = MBNavigationStackTaskPushType;
    t.viewController = viewController;
    t.animated = animated;
    return t;
}

+ (instancetype)popTaskAnimated:(BOOL)animated {
    MBNavigationStackTask *t = [MBNavigationStackTask new];
    t.type = MBNavigationStackTaskPopType;
    t.animated = animated;
    return t;
}

+ (instancetype)popToTaskWithViewController:(UIViewController *)viewController animated:(BOOL)animated {
    MBNavigationStackTask *t = [MBNavigationStackTask new];
    t.type = MBNavigationStackTaskPopType;
    t.viewController = viewController;
    t.animated = animated;
    return t;
}

+ (instancetype)setTaskWithViewControllers:(NSArray<UIViewController *> *)viewControllers animated:(BOOL)animated {
    MBNavigationStackTask *t = [MBNavigationStackTask new];
    t.type = MBNavigationStackTaskSetType;
    t.viewControllers = viewControllers;
    t.animated = animated;
    return t;
}

+ (NSArray<UIViewController *> *)processedStackWithTasks:(NSArray<MBNavigationStackTask *> *)tasks stackBefore:(NSArray<UIViewController *> *)viewControllers shouldAnimated:(nullable BOOL *)animatedRef {
    if (!tasks.count) return nil;
    NSMutableArray *stack = [NSMutableArray arrayWithArray:viewControllers];
    BOOL shouldAnimated = NO;
    for (MBNavigationStackTask *task in tasks) {
        if (task.type == MBNavigationStackTaskPushType) {
            if (!task.viewController) continue;
            [stack addObject:task.viewController];
            shouldAnimated = task.animated;
        }
        else if (task.type == MBNavigationStackTaskPopType) {
            if (task.viewController) {
                // pop to
                NSInteger idx = [stack indexOfObject:task.viewController];
                if (idx == NSNotFound) continue;
                NSInteger length = stack.count - idx - 1;
                if (length <= 0) continue;
                [stack removeObjectsInRange:NSMakeRange(idx +1, length)];
                shouldAnimated = task.animated;
            }
            else {
                [stack removeLastObject];
                shouldAnimated = task.animated;
            }
        }
        else if (task.type == MBNavigationStackTaskSetType) {
            if (!task.viewControllers) continue;
            [stack setArray:task.viewControllers];
            shouldAnimated = task.animated;
        }
    }
    if (animatedRef) {
        *animatedRef = shouldAnimated;
    }
    return stack;
}

@end
