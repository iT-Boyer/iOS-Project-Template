/*
 MBDebugHelpers
 
 Copyright © 2018 RFUI.
 Copyright © 2016 Beijing ZhiYun ZhiYuan Technology Co., Ltd.
 https://github.com/BB9z/iOS-Project-Template
 
 The MIT License
 https://opensource.org/licenses/MIT
 */
#import <MBAppKit/MBAppKit.h>

/**
 当前界面可以把一些跟自己相关的调试项加到调试浮层中
 */
@protocol MBDebugCommandItemSource <NSObject>

- (NSArray<UIBarButtonItem *> *_Nonnull)debugCommands;

@end

@protocol MBDebugVisableItemInspecting <NSObject>

- (void)mbdebug_showVisableItemMenu;

@end


@interface UITableView (MBDebugVisableItemInspecting) <
    MBDebugVisableItemInspecting
>
@end


@interface UICollectionView (MBDebugVisableItemInspecting) <
    MBDebugVisableItemInspecting
>
@end

UIBarButtonItem *_Nonnull DebugMenuItem(NSString *_Nonnull title, id _Nullable target, SEL _Nullable action);
UIBarButtonItem *_Nonnull DebugMenuItem2(NSString *_Nonnull title, dispatch_block_t _Nonnull actionBlock);

/// ClassName(uid) 或 ClassName(address)
NSString *_Nonnull DebugItemDescription(id _Nonnull item);

/// 弹出 UI 展示指定对象
void DebugUIInspecteModel(id _Nullable model);

/// 弹出列表，按给定方式显示出这些对象，点击按给定方式处理对象
void DebugUIInspecteObjects(NSString *_Nonnull title, NSArray<id> *_Nonnull objects, NSString *_Nonnull (^_Nullable titleDisplay)(id _Nonnull), void (^_Nullable inspectBlock)(id _Nonnull));
