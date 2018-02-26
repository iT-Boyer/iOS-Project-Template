/*!
 UIKit+App

 Copyright © 2016 Beijing ZhiYun ZhiYuan Technology Co., Ltd. All rights reserved.
 https://github.com/zhiyun168/Feel-iOS
 */

#import "UIKit+App.h"

@interface UITableView (App)
- (void)appendAtRang:(NSRange)rang inSection:(NSUInteger)section animated:(BOOL)animated;
@property (nonatomic, readonly, nullable) NSArray<NSIndexPath *> *indexPathsForVisibleCells;
@end
