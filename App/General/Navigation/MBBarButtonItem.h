//
//  MBBarButtonItem.h
//  Feel
//
//  Created by BB9z on 08/02/2017.
//  Copyright © 2017 Beijing ZhiYun ZhiYuan Technology Co., Ltd. All rights reserved.
//

#import "CommonUI.h"

/**
 UIBarButtonItem 扩展基类
 */
@interface MBBarButtonItem : UIBarButtonItem

/// 跳转链接，如果设置了其他 action 则不起作用
@property (nonatomic) IBInspectable NSString *jumpURL;
@end
