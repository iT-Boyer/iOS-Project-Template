//
//  MBLabel.h
//  Feel
//
//  Created by BB9z on 1/22/16.
//  Copyright © 2016 Beijing ZhiYun ZhiYuan Technology Co., Ltd. All rights reserved.
//

#import "RFReferenceSizing.h"

/**
 主要提供文字随尺寸变化而变化的功能
 */
@interface MBLabel : UILabel <
    RFInitializing,
    RFReferenceSizing
>

@property (nonatomic) IBInspectable CGFloat referenceSize;
@property (nonatomic) CGFloat fontReferenceSize;

@property (nonatomic) CGFloat referenceSizingConstant;

@property (nonatomic, weak) IBOutlet UIView *referenceSizingFrameView;
@property (nonatomic) IBInspectable CGFloat referenceSizingFactor;

@end
