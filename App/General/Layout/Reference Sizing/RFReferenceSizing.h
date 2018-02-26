//
//  RFReferenceSizing.h
//  Feel
//
//  Created by BB9z on 1/22/16.
//  Copyright © 2016 Beijing ZhiYun ZhiYuan Technology Co., Ltd. All rights reserved.
//

#import "Common.h"

/**
 元素尺寸随屏幕改变而调整

 */
@protocol RFReferenceSizing <NSObject>
@required

/// 参照基础量
@property (nonatomic) IBInspectable CGFloat referenceSize;

/// 当前量，更新这个值改来调整当前元素尺寸
@property (nonatomic) IBInspectable CGFloat referenceSizingConstant;

@optional

/// 一般通过外部 view 来更新 referenceSizingConstant
@property (nonatomic, weak) IBOutlet UIView *referenceSizingFrameView;

/// 影响缩放变化比率
@property (nonatomic) IBInspectable CGFloat referenceSizingFactor;

- (void)setNeedsUpdateReferenceSize;
@end

/**
 @param referenceSize 不能是 0
 */
extern double RFReferenceSizeRate(CGFloat referenceSize, CGFloat constant, CGFloat factor);;
