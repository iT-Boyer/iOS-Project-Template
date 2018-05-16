/*!
 MBCollectionViewEqualColumnSpaceLayout
 
 Copyright © 2018 RFUI.
 Copyright © 2016 Beijing ZhiYun ZhiYuan Technology Co., Ltd.
 https://github.com/BB9z/iOS-Project-Template
 
 Apache License, Version 2.0
 http://www.apache.org/licenses/LICENSE-2.0
 */

#import "MBCollectionViewFlowLayout.h"

/**
 Cell 间距和整个 frame 间距保持相同

 仅支持单Section，单Cell类型。
 */
@interface MBCollectionViewEqualColumnSpaceLayout : MBCollectionViewFlowLayout

@property (nonatomic) IBInspectable NSUInteger numberOfColumns;

@end
