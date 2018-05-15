/*!
 UICollectionView+IBSelection
 
 Copyright © 2018 RFUI.
 Copyright © 2015 Beijing ZhiYun ZhiYuan Technology Co., Ltd.
 https://github.com/RFUI/MBAppKit
 
 Apache License, Version 2.0
 http://www.apache.org/licenses/LICENSE-2.0
 */

#import "UIKit+IBInspectable.h"

/**
 Stroyboard 中没提供这两项的开关
 */
@interface UICollectionView (IBSelection)
@property (nonatomic) IBInspectable BOOL allowsSelection;
@property (nonatomic) IBInspectable BOOL allowsMultipleSelection;
@end
