//
//  UIView+AutoresizingMask.h
//  Feel
//
//  Created by BB9z on 8/23/15.
//  Copyright (c) 2015 Beijing ZhiYun ZhiYuan Technology Co., Ltd. All rights reserved.
//

#import "UIKit+IBInspectable.h"

/**
 Stroyboard 中没提供这两项的开关
 */
@interface UICollectionView (IBSelection)
@property (nonatomic) IBInspectable BOOL allowsSelection;
@property (nonatomic) IBInspectable BOOL allowsMultipleSelection;
@end
