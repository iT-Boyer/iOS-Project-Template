/*!
 UIKit+App

 Copyright © 2016 Beijing ZhiYun ZhiYuan Technology Co., Ltd.
 https://github.com/BB9z/iOS-Project-Template
 
 Apache License, Version 2.0
 http://www.apache.org/licenses/LICENSE-2.0
 */
#import <Foundation/Foundation.h>

@interface NSArray<ObjectType> (App)

/**
 构建新的历史记录数组，新的历史排在最前面，会去重复

 reciver 是旧的历史

 @param items 新的历史
 @param limit 历史记录条数限制，不限制需传入 NSIntegerMax 而不能是 0
 */
- (nonnull NSArray<ObjectType> *)historyArrayWithNewItems:(nullable NSArray *)items limit:(NSUInteger)limit;

@end


@interface NSMutableArray<ObjectType> (ZYAdd)

/**
 安全地替换数组中指定位置的元素
 
 index越界或者anObject为nil时不进行任何操作
 */
- (void)rf_replaceObjectAtIndex:(NSUInteger)index withObject:(nullable id)anObject;

/**
 将数组元素从一个位置移动另一个位置
 */

- (void)moveObjectAtIndex:(NSUInteger)fromIndex toIndex:(NSUInteger)toIndex;

@end
