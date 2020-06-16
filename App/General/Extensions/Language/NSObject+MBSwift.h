/*
 NSObject+MBSwift
 
 Copyright © 2019 RFUI.
 https://github.com/BB9z/iOS-Project-Template
 
 The MIT License
 https://opensource.org/licenses/MIT
 */

#import <Foundation/Foundation.h>

/**
 帮助在 Swift 中实现一些仅靠 Swift 难于实现的功能
 */
@interface NSObject (MBSwift)

/**
 将输入包装为当前类的实例
 
 典型场景：在 class func 实现中生成 Self 类型的实例
 */
+ (nonnull instancetype)mbswift_instanceType:(nonnull id)object;

@end
