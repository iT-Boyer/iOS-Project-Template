/*
 MBLabel
 
 Copyright © 2018 RFUI.
 Copyright © 2016 Beijing ZhiYun ZhiYuan Technology Co., Ltd.
 https://github.com/BB9z/iOS-Project-Template
 
 Apache License, Version 2.0
 http://www.apache.org/licenses/LICENSE-2.0
 */
#import <RFInitializing/RFInitializing.h>
#import <RFKit/RFRuntime.h>
#import "RFReferenceSizing.h"

// @MBDependency:0
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
