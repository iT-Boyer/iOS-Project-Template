/*!
 UIKit+App

 Copyright © 2016 Beijing ZhiYun ZhiYuan Technology Co., Ltd. All rights reserved.
 https://github.com/zhiyun168/Feel-iOS
 */

#import "UIKit+App.h"

@interface UICollectionView (App)

/**
 便捷方法，通过类名找相应 nib 注册，且 cell 的 reuse identifier 也是类名
 */
- (void)registerNibWithClass:(nonnull Class)aClass;

/**
 安全的刷新只有一个 section 的 collection view
 collection view 在正在滚动时，reloadData 不会立即执行，于是可能出现数据更新了，但是 collection view 状态没同步，导致崩溃
 */
- (void)safeReloadAnimated:(BOOL)animated;

- (void)deselectItemsAnimated:(BOOL)animated;

@end
