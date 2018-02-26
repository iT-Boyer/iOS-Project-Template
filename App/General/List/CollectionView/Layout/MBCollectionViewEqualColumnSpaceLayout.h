//
//  MBCollectionViewEqualColumnSpaceLayout.h
//  Feel
//
//  Created by ddhjy on 7/26/16.
//  Copyright © 2016 Beijing ZhiYun ZhiYuan Technology Co., Ltd. All rights reserved.
//

#import "MBCollectionViewFlowLayout.h"

/**
 Cell 间距和整个 frame 间距保持相同

 仅支持单Section，单Cell类型。
 */
@interface MBCollectionViewEqualColumnSpaceLayout : MBCollectionViewFlowLayout

@property (nonatomic) IBInspectable NSUInteger numberOfColumns;

@end
