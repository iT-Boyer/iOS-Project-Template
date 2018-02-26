//
//  ZYUtility.h
//  Feel
//
//  Created by ddhjy on 28/10/2016.
//  Copyright © 2016 Beijing ZhiYun ZhiYuan Technology Co., Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <objc/runtime.h>

@interface ZYUtility : NSObject

// Swizzling utilities

+ (SEL)swizzledSelectorForSelector:(SEL)selector;
+ (BOOL)instanceRespondsButDoesNotImplementSelector:(SEL)selector class:(Class)cls;
+ (void)replaceImplementationOfKnownSelector:(SEL)originalSelector onClass:(Class)class withBlock:(id)block swizzledSelector:(SEL)swizzledSelector;
+ (void)replaceImplementationOfSelector:(SEL)selector withSelector:(SEL)swizzledSelector forClass:(Class)cls withMethodDescription:(struct objc_method_description)methodDescription implementationBlock:(id)implementationBlock undefinedBlock:(id)undefinedBlock;

// Default shadow

+ (void)configDefaultShadowToLayer:(CALayer *)layer;
+ (void)configDefaultShadowToLayer:(CALayer *)layer withColor:(UIColor *)color;
+ (void)configShadowToLayer:(CALayer *)layer withColor:(UIColor *)color offSet:(CGSize)offSet opacity:(CGFloat)opacity radius:(CGFloat)radius;
/**
 给 view 加上默认主题色阴影，所有按钮加阴影通用的设置
 扩散较大
 */
+ (void)applyTintShadowOnView:(UIView *)view;

+ (CGSize)sizeForString:(NSString *)aString withBoundingSize:(CGSize)size fontSize:(CGFloat)fontSize;

@end
