//
//  MBNavigationTitleView.h
//  Feel
//
//  Created by BB9z on 4/29/15.
//  Copyright (c) 2015 Beijing ZhiYun ZhiYuan Technology Co., Ltd. All rights reserved.
//

#import "Common.h"

/**
 设置为 UINavigationItem 的 titleView，在显示出来的时候会填满导航条（除了左右按钮的空间）
 */
@interface MBNavigationTitleView : UIView

/**
 默认行为是填满除了左右按钮的空间，这样的话 UI 可能不会相对于屏幕居中
 把这个属性置为 YES 会保持居中，但空间可能就有多余了
 */
@property IBInspectable BOOL keepCenterLayout;
@end
