//
//  MBSimpleImageCollectionViewCell.h
//  Feel
//
//  Created by BB9z on 21/10/2016.
//  Copyright © 2016 Beijing ZhiYun ZhiYuan Technology Co., Ltd. All rights reserved.
//

#import "CommonUI.h"

/**
 简单的 cell，除了一个 image view 外什么都没加
 */
@interface MBSimpleImageCollectionViewCell : UICollectionViewCell
@property (nonatomic, nullable, weak) IBOutlet UIImageView *imageView;
@end
