//
//  MBDesignView.h
//  Feel
//
//  Created by BB9z on 1/27/15.
//  Copyright (c) 2015 Beijing ZhiYun ZhiYuan Technology Co., Ltd. All rights reserved.
//

#import "Common.h"

/**
 在 IB 中为了看清浅色元素或者为了标记区域，可以给 view 设置背景色，运行时再清空

 这个 view 会在 awakeFromNib 时自动清空背景色
 */
@interface MBDesignView : UIView
@end
