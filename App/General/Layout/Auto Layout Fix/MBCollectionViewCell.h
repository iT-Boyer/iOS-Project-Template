/*!
    MBCollectionViewCell

    Copyright © 2014-2016 Beijing ZhiYun ZhiYuan Information Technology Co., Ltd.
    https://github.com/Chinamobo/iOS-Project-Template

    Apache License, Version 2.0
    http://www.apache.org/licenses/LICENSE-2.0
 */
#import "RFUI.h"

NS_ASSUME_NONNULL_BEGIN

/**
 iOS 8 SDK 编译的 UICollectionViewCell，在 nib 中创建的子 view 约束会“失效”，因为 contentView 不会出现在 nib 中并且不会强制填满 UICollectionViewCell
 
 另直接通过给 UICollectionViewCell 添加扩展的方式重定义 awakeFromNib 实测也可修复这个问题，不过还是子类更规矩一些
 */
@interface MBCollectionViewCell : UICollectionViewCell <
    RFInitializing
>
@property (strong, nonatomic) id item;

/**
 协议方法，collectionView:didSelectItemAtIndexPath: 时尝试执行这个方法

 默认什么也不做
 */
- (void)onCellSelected;
@end

NS_ASSUME_NONNULL_END
