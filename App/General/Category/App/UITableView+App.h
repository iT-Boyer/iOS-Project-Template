/*
 UITableView+App

 Copyright © 2018 RFUI.
 Copyright © 2016 Beijing ZhiYun ZhiYuan Technology Co., Ltd.
 https://github.com/BB9z/iOS-Project-Template
 
 Apache License, Version 2.0
 http://www.apache.org/licenses/LICENSE-2.0
 */

#import "UIKit+App.h"

@interface UITableView (App)

// @MBDependency:1
- (void)appendAtRang:(NSRange)rang inSection:(NSUInteger)section animated:(BOOL)animated;

// @MBDependency:2
@property (nonatomic, readonly, nullable) NSArray<NSIndexPath *> *indexPathsForVisibleCells;
@end
