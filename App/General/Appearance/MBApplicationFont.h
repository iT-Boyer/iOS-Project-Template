//
//  MBApplicationFont.h
//  Feel
//
//  Created by BB9z on 4/29/15.
//  Copyright (c) 2015 Beijing ZhiYun ZhiYuan Technology Co., Ltd. All rights reserved.
//

#import "Common.h"

@interface UIFont (MBApplicationFont)

/**
 设置全局 label 的字体
 
 @param name 字体的 PostScript name
 */
+ (void)setApplicaitonDefaultFontWithFontName:(NSString *)name;

/**
 
 */
+ (UIFont *)MBApplicationFontOfSize:(CGFloat)fontSize;

@end


@interface UILabel (MBApplicationFont)

- (void)setDefaultApplicationFontWithFontName:(NSString *)name UI_APPEARANCE_SELECTOR;

@end

@interface UITextField (MBApplicationFont)

- (void)setDefaultApplicationFontWithFontName:(NSString *)name UI_APPEARANCE_SELECTOR;

@end

@interface UITextView (MBApplicationFont)

- (void)setDefaultApplicationFontWithFontName:(NSString *)name UI_APPEARANCE_SELECTOR;

@end
