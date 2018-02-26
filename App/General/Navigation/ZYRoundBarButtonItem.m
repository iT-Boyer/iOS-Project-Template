//
//  ZYRoundBarButtonItem.m
//  Feel
//
//  Created by ddhjy on 9/9/16.
//  Copyright © 2016 Beijing ZhiYun ZhiYuan Technology Co., Ltd. All rights reserved.
//

#import "ZYRoundBarButtonItem.h"
#import "MBButton.h"
#import "RFDrawImage.h"
#import "UIView+RFLayerApperance.h"

@implementation ZYRoundBarButtonItem

- (void)awakeFromNib {
    [super awakeFromNib];
    [self _ZYRoundBarButtonItem_setupCustomView];
}

- (void)_ZYRoundBarButtonItem_setupCustomView {
    UIButton *contentButton = [UIButton buttonWithType:UIButtonTypeCustom];
    UIColor *color = self.tintColor;
    UIColor *highlightColor = color.rf_darkerColor;
    UIImage *backgrounImage = [RFDrawImage imageWithRoundingCorners:UIEdgeInsetsMakeWithSameMargin(3) size:CGSizeMake(7, 7) fillColor:color strokeColor:nil strokeWidth:0 boxMargin:UIEdgeInsetsZero resizableCapInsets:UIEdgeInsetsMakeWithSameMargin(3) scaleFactor:0];
    UIImage *backgrounHighlightImage = [RFDrawImage imageWithRoundingCorners:UIEdgeInsetsMakeWithSameMargin(3) size:CGSizeMake(7, 7) fillColor:highlightColor strokeColor:nil strokeWidth:0 boxMargin:UIEdgeInsetsZero resizableCapInsets:UIEdgeInsetsMakeWithSameMargin(3) scaleFactor:0];

    [contentButton setBackgroundImage:backgrounImage forState:UIControlStateNormal];
    [contentButton setBackgroundImage:backgrounHighlightImage forState:UIControlStateHighlighted];
    contentButton.titleLabel.font = [UIFont systemFontOfSize:14];
    contentButton.text = self.title;
    CGRect buttonFrame = ({
        CGRect frame = CGRectZero;
        CGSize preferSize = contentButton.intrinsicContentSize;
        preferSize.width += 10;
        preferSize.height = contentButton.titleLabel.font.pointSize + 10;
        frame.size = preferSize;
        frame;
    });
    contentButton.frame = buttonFrame;
    [contentButton addTarget:self action:@selector(_ZYRoundBarButtonItem_buttonTapped:) forControlEvents:UIControlEventTouchUpInside];
    
    // 按钮相对于系统默认位置的偏移
    UIOffset offset = UIOffsetMake(6, 0);
    MBControlTouchExpandContainerView *layoutOffsetView = [[MBControlTouchExpandContainerView alloc] init];
    layoutOffsetView.controls = @[contentButton];
    layoutOffsetView.bounds = ({
        CGRect bounds = buttonFrame;
        bounds.size.height -= offset.vertical * 2;
        bounds.size.width -= offset.horizontal;
        bounds;
    });
    [layoutOffsetView addSubview:contentButton];
    
    self.customView = layoutOffsetView;
}

- (void)_ZYRoundBarButtonItem_buttonTapped:(UIButton *)button {
    [[UIApplication sharedApplication] sendAction:self.action to:self.target from:self forEvent:nil];
}

@end
