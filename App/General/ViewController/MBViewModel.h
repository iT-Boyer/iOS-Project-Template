//
//  MBViewModel.h
//  Feel
//
//  Created by BB9z on 21/11/2016.
//  Copyright © 2016 Beijing ZhiYun ZhiYuan Technology Co., Ltd. All rights reserved.
//

#import "Common.h"

/**
 view model 基类
 
 使用：
 
 这个东西只有 view controller 自己知道，vc 每次显示的时候去更新它，它负责把发生的变化通知给 vc
 
 状态一般都用 obj 对象声明，解决不知道是否设置过的问题。如果设置是一次性的，方便使用的 bool 也是可以考虑的。

 这个 model 跟 view 走，那么创建的时机应该是 viewDidLoad——别忘了 view 是可以销毁重建的，虽然我们现在几乎不这么做。

 @code
 
- (void)viewDidLoad {
    [super viewDidLoad];

    // view model 应在 viewDidLoad 时创建
    ZYGLViewModel *vm = [[ZYGLViewModel alloc] initWithViewController:self];
    // 并初始化
    [vm initStatus];
    self.viewModel = vm;
}
 
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    // 在 viewWillAppear: 或 viewDidAppear: 里更新 view model 状态
    [self.viewModel updateStatus];
}

 @endcode
 
 view controller 上一般要实现属性变化的响应方法，必须且只能接受状态 from、to 两个参数
 */
@interface MBViewModel : NSObject

- (null_unspecified instancetype)init NS_UNAVAILABLE;
- (nonnull instancetype)initWithViewController:(nonnull id)viewController NS_DESIGNATED_INITIALIZER;

@property (nonatomic, nullable, readonly, weak) id viewController;


/**
 用来禁用状态变化时发出通知的，一般在 view model 设置初始化状态时
 */
@property BOOL disableNotice;

@end


/**
 属性 setter 执行方法
 
 例子：
 @code
 - (void)setJoined:(NSNumber *)joined {
     MBViewModelPropertySetterIMP(self, &_joined, joined, @selector(updateUIForJoinedChangeFrom:to:));
 }
 @endcode

 @param self 对象实例
 @param oldValue 属性历史值
 @param newValue 属性新的值
 @param noticeSelector 调用通知的方法，必须能接受 from、to 两个参数
 */
void MBViewModelPropertySetterIMP(__kindof MBViewModel *__nonnull self, id __strong __nullable *__nonnull oldValue, id __nullable newValue, SEL __nonnull noticeSelector);
