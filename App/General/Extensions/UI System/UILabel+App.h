/*
 UILabel+App
 
 Copyright © 2018 RFUI.
 Copyright © 2016 Beijing ZhiYun ZhiYuan Technology Co., Ltd.
 Copyright © 2014 Chinamobo Co., Ltd.
 https://github.com/BB9z/iOS-Project-Template
 
 The MIT License
 https://opensource.org/licenses/MIT
 */

#import "UIKit+App.h"

@interface UILabel (App)

// @MBDependency:1
/**
 用带单位的文本设置 label，可以指定单位部分的字体

 @param valueText 一段带单位文本
 @param unitRang 单位在文本中的范围
 @param unitFont 单位部分应该应用的字体
 */
- (void)setAttributedTextWithValueText:(nullable NSString *)valueText unitRange:(NSRange)unitRang unitFont:(nullable UIFont *)unitFont;

@end
