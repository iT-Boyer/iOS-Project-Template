//
//  ZYUtility.m
//  Feel
//
//  Created by ddhjy on 28/10/2016.
//  Copyright © 2016 Beijing ZhiYun ZhiYuan Technology Co., Ltd. All rights reserved.
//

#import "ZYUtility.h"
#import "UIColor+App.h"

@implementation ZYUtility

+ (SEL)swizzledSelectorForSelector:(SEL)selector
{
    return NSSelectorFromString([NSString stringWithFormat:@"_flex_swizzle_%x_%@", arc4random(), NSStringFromSelector(selector)]);
}

+ (BOOL)instanceRespondsButDoesNotImplementSelector:(SEL)selector class:(Class)cls
{
    if ([cls instancesRespondToSelector:selector]) {
        unsigned int numMethods = 0;
        Method *methods = class_copyMethodList(cls, &numMethods);
        
        BOOL implementsSelector = NO;
        for (int index = 0; index < numMethods; index++) {
            SEL methodSelector = method_getName(methods[index]);
            if (selector == methodSelector) {
                implementsSelector = YES;
                break;
            }
        }
        
        free(methods);
        
        if (!implementsSelector) {
            return YES;
        }
    }
    
    return NO;
}

+ (void)replaceImplementationOfKnownSelector:(SEL)originalSelector onClass:(Class)class withBlock:(id)block swizzledSelector:(SEL)swizzledSelector
{
    // This method is only intended for swizzling methods that are know to exist on the class.
    // Bail if that isn't the case.
    Method originalMethod = class_getInstanceMethod(class, originalSelector);
    if (!originalMethod) {
        return;
    }
    
    IMP implementation = imp_implementationWithBlock(block);
    class_addMethod(class, swizzledSelector, implementation, method_getTypeEncoding(originalMethod));
    Method newMethod = class_getInstanceMethod(class, swizzledSelector);
    method_exchangeImplementations(originalMethod, newMethod);
}

+ (void)replaceImplementationOfSelector:(SEL)selector withSelector:(SEL)swizzledSelector forClass:(Class)cls withMethodDescription:(struct objc_method_description)methodDescription implementationBlock:(id)implementationBlock undefinedBlock:(id)undefinedBlock
{
    if ([self instanceRespondsButDoesNotImplementSelector:selector class:cls]) {
        return;
    }
    
    IMP implementation = imp_implementationWithBlock((id)([cls instancesRespondToSelector:selector] ? implementationBlock : undefinedBlock));
    
    Method oldMethod = class_getInstanceMethod(cls, selector);
    if (oldMethod) {
        class_addMethod(cls, swizzledSelector, implementation, methodDescription.types);
        
        Method newMethod = class_getInstanceMethod(cls, swizzledSelector);
        
        method_exchangeImplementations(oldMethod, newMethod);
    } else {
        class_addMethod(cls, selector, implementation, methodDescription.types);
    }
}

+ (void)configDefaultShadowToLayer:(CALayer *)layer {
    [self configDefaultShadowToLayer:layer withColor:[UIColor blackColor]];
}

+ (void)configDefaultShadowToLayer:(CALayer *)layer withColor:(UIColor *)color {
    layer.shadowColor = color.CGColor;
    layer.shadowOffset = CGSizeMake(0, 2);
    layer.shadowOpacity = 0.1;
    layer.shadowRadius = 4.0;
}

+ (void)applyTintShadowOnView:(UIView *)view {
    if (!view) return;
    CALayer *l = view.layer;
    l.shadowColor = [UIColor globalTintColor].CGColor;
    l.shadowRadius = 12;
    l.shadowOpacity = 0.6;
    l.shadowOffset = CGSizeMake(0, 6);
}

+ (void)configShadowToLayer:(CALayer *)layer withColor:(UIColor *)color offSet:(CGSize)offSet opacity:(CGFloat)opacity radius:(CGFloat)radius {
    layer.shadowColor = color.CGColor;
    layer.shadowOffset = offSet;
    layer.shadowOpacity = opacity;
    layer.shadowRadius = radius;
    
}
+ (CGSize)sizeForString:(NSString *)aString withBoundingSize:(CGSize)size fontSize:(CGFloat)fontSize {
    UIFont *ft = [UIFont systemFontOfSize:fontSize];
    return [aString boundingRectWithSize:size options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingTruncatesLastVisibleLine attributes:@{ NSFontAttributeName : ft } context:nil].size;
}

@end
