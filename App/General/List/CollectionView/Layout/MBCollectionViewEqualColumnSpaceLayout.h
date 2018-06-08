/*!
 MBCollectionViewEqualColumnSpaceLayout
 
 Copyright © 2018 RFUI.
 https://github.com/BB9z/iOS-Project-Template
 
 Apache License, Version 2.0
 http://www.apache.org/licenses/LICENSE-2.0
 */

#import "MBCollectionViewFlowLayout.h"

/**
 按照 collectionView 的宽度均分成 numberOfColumns 列，
 使得 sectionInset 的左右和 minimumInteritemSpacing 相同
 */
@interface MBCollectionViewEqualColumnSpaceLayout : MBCollectionViewFlowLayout

@property (nonatomic) IBInspectable NSUInteger numberOfColumns;

@end
