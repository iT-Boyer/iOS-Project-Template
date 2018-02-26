//
//  UILabel+App.h
//  Feel
//
//  Created by BB9z on 24/11/2016.
//  Copyright © 2016 Beijing ZhiYun ZhiYuan Technology Co., Ltd. All rights reserved.
//

#import "UIKit+App.h"

@interface UILabel (App)

/**
 根据 label 高度，返回一个与之相符的文字尺寸
 */
- (CGFloat)RFSuggestFontSizeAccordingToLabelHight;

/**
 根据 label 高度，返回一个字号与之相符的字体

 @param rato 字号比率，默认应该传 1，传 0 相当于传 1
 @return 返回字体与 label 相同，字号按 label 当前高度计算的字体
 */
- (nonnull UIFont *)RFSuggestFontWithSizeRato:(double)rato;

/**
 用带单位的文本设置 label，可以指定单位部分的字体

 @param valueText 一段带单位文本
 @param unitRang 单位在文本中的范围
 @param unitFont 单位部分应该应用的字体
 */
- (void)setAttributedTextWithValueText:(nullable NSString *)valueText unitRange:(NSRange)unitRang unitFont:(nullable UIFont *)unitFont;

@end
