/*!
 MBRootWrapperViewController
 
 Copyright © 2018 RFUI. All rights reserved.
 Copyright © 2014-2017 Beijing ZhiYun ZhiYuan Technology Co., Ltd.
 https://github.com/RFUI/MBAppKit
 
 Apache License, Version 2.0
 http://www.apache.org/licenses/LICENSE-2.0
 */
#import <RFKit/RFRuntime.h>

/**
 整个应用的根 vc，除了是主导航的容器外，还承担了很多其他功能
 
 - 启动图的显示管理
 - 管理应用级别的提示，各种气泡，教程提示
 - 为 view 截图提供支持（截图时为了使 Auto Layout 生效，需要把 view 先加入到 view hierarchy 中）
 */
@interface MBRootWrapperViewController : UIViewController

+ (null_unspecified instancetype)globalController;

@end

#pragma mark - View 截图

@interface MBRootWrapperViewController (ViewSnap)

/**
 @param width CGFLOAT_MAX 不设置宽度，内容自适应
 */
- (void)setupRenderView:(nonnull UIView *)viewToRendering width:(CGFloat)width;
/// 渲染区域适应 viewToRendering 大小
- (void)setupRenderView:(nonnull UIView *)viewToRendering;

- (nonnull UIImage *)renderThenCleanWithView:(nonnull UIView *)viewToRendering;

/// 尽量用 renderThenCleanWithView: 而不是这个方法
- (nullable UIImage *)renderThenClean;

@end
