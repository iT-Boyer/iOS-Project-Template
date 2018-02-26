//
//  MBViewUpdateController.h
//  Feel
//
//  Created by BB9z on 19/01/2017.
//  Copyright © 2017 Beijing ZhiYun ZhiYuan Technology Co., Ltd. All rights reserved.
//

#import "Common.h"

@protocol MBViewUpdateControllerDelegate;

/**
 背景
 
    已经有了 MBViewModel，解决了数据变化的探知。但 view model 现在的通知方式设计之初没考虑多状态相互影响，导致本来跟业务无关的 view model 需要考量业务逻辑。还有对刷新时机控制无力，不能避免反复刷。
    
    不是说反复刷不行，大部分情况效率上不会到非优化不可的地步，既然需要 view model 就是有局部刷的需求，局部刷的动因之一是需要做动画，一下刷了好几次动画怎么做？
 
    多状态刷新要有一个集中控制才能避免反复刷，另外数据状态和视图的状态并不是一一对应的，需要引入视图这层的控制器，这就是 MBViewUpdateController 的作用。
 
    整体架构变成了（这回真成了 MVVM 了？）：
 
    Model - MBViewModel - MBViewUpdateController - View
 
 使用流程概述
 
    一般情况，整个流程设计上是这样的，VC 上有 view model（以下简称 VM），view update controller（以下简称 UC）。VC 在显示时，用当前数据的状态去更新 VM，VM 连接 UC，把变化传递给 UC；UC 状态变更会调用 VC 的刷新，最后 VC 按照 UC 的指示刷新必要的 view。
 
    VC 还可以手工设置 UC 的状态，UC 状态变了回去调 VC 的刷新方法。
 
    角色分工可以总结为，VM 是业务无关的，只用来监测 model 变化；UC 是 VC 的附属辅助，要结合 VC 来设计界面；这里 VC 不一定非得是 UIViewController，用来更新复杂的 view 也是可以的。
 
 具体使用
 
    子类 MBViewUpdateController，跟相应 VC 可以写一起，加上需要的状态参数；
    实现 view model 里的更新方法；
    暂时实验，没实现属性自动生成，需要手工调用通知方法，详见下面的界面。
 
 */
@interface MBViewUpdateController : NSObject

- (void)addDisplayer:(nullable id<MBViewUpdateControllerDelegate>)displayer;
- (void)removeDisplayer:(nullable id<MBViewUpdateControllerDelegate>)displayer;

/**
 目前没有属性自动生成，当状态熟悉变化后，你需要调用这个方法以便通知 delegate 刷新 view
 
 刷新请求将在一小会儿后发出
 */
- (void)setNeedsNoticeDelegateToUpdate;

/**
 立即通知 delegate 刷新，如非必要，应该总是用 setNeedsNoticeDelegateToUpdate
 */
- (void)noticeDelegateToUpdate;

@end


@protocol MBViewUpdateControllerDelegate <NSObject>
@required
- (void)updateUIWithUpdateController:(nonnull __kindof MBViewUpdateController *)uc;

@end

@interface MBViewUpdateController (MBIBOutletSupport)
/// 仅方便在 IB 中添加 displayer，没有 getter，不会持有数组
@property (nullable, weak) IBOutletCollection(id) NSArray *linkDisplayer;
@end
