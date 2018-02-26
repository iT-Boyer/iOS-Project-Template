//
//  MBPageScrollView.h
//  Very+
//
//  Created by BB9z on 8/9/14.
//  Copyright (c) 2014 Beijing ZhiYun ZhiYuan Information Technology Co., Ltd. All rights reserved.
//

#import "Common.h"

/**
 分页支持的 ScrollView
 
 */
@interface MBPageScrollView : UIScrollView <
    RFInitializing
>

@property(nonatomic) NSInteger page;
- (void)setPage:(NSInteger)page animated:(BOOL)animated;

@property (readonly, nonatomic) NSInteger totalPage;

@end


@interface UIScrollView (MBPageScrolling)

- (NSInteger)MBPage;

- (void)MBSetPage:(NSInteger)page animated:(BOOL)animated;

@end
