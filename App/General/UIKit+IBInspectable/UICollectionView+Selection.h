/*
 UICollectionView+IBSelection
 
 Copyright © 2018 RFUI.
 Copyright © 2015 Beijing ZhiYun ZhiYuan Technology Co., Ltd.
 https://github.com/BB9z/iOS-Project-Template
 
 The MIT License
 https://opensource.org/licenses/MIT
 */

#import "UIKit+IBInspectable.h"

/**
 Stroyboard 中没提供这两项的开关
 */
@interface UICollectionView (IBSelection)
@property (nonatomic) IBInspectable BOOL allowsSelection;
@property (nonatomic) IBInspectable BOOL allowsMultipleSelection;
@end
