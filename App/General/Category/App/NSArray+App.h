/*!
 UIKit+App

 Copyright © 2016 Beijing ZhiYun ZhiYuan Technology Co., Ltd. All rights reserved.
 https://github.com/zhiyun168/Feel-iOS
 */

#import "UIKit+App.h"

@interface NSArray<ObjectType> (App)

/**
 返回数组中的随机一个元素
 */
- (nonnull ObjectType)randomObject;

/**
 构建新的历史记录数组，新的历史排在最前面，会去重复

 reciver 是旧的历史

 @param items 新的历史
 @param limit 历史记录条数限制，不限制需传入 NSIntegerMax 而不能是 0
 */
- (nonnull NSArray<ObjectType> *)historyArrayWithNewItems:(nullable NSArray *)items limit:(NSUInteger)limit;

/**
 Returns an array containing the results of mapping transform over self.

 @return The mutable array returned may has a diffrent count with the receiver.
 */
- (nonnull NSMutableArray *)rf_mapedArrayWithBlock:(NS_NOESCAPE id _Nullable (^_Nonnull)(ObjectType _Nonnull))block;

/**
 返回从当前数组中移除指定元素的新的数组
 */
- (nonnull NSArray *)arrayByRemovingObject:(nullable ObjectType)anObject;

/**
 返回从当前数组中移除指定元素的新的数组
 */
- (nonnull NSMutableArray<ObjectType> *)arrayByRemovingObjectsPassingTest:(BOOL (^_Nonnull)(ObjectType _Nonnull obj, NSUInteger idx, BOOL *_Nonnull stop))predicate;


/**
 判断两数组是否有交集
 */
- (BOOL)containsAnyObjectInArray:(nullable NSArray *)otherArray;

/**
 A = B
 A 包含 B、B 包含 A
 */
- (BOOL)isEqualToArrayIgnoringOrder:(nullable NSArray *)otherArray;

@end


@interface NSMutableArray<ObjectType> (ZYAdd)

/**
 安全地替换数组中指定位置的元素
 
 index越界或者anObject为nil时不进行任何操作
 */
- (void)zy_replaceObjectAtIndex:(NSUInteger)index withObject:(nullable id)anObject;

/**
 只保留在给定数组中的元素，传入数组是空的话，会移除全部
 */
- (void)removeObjectsNotInArray:(nullable NSArray *)otherArray;

/**
 将数组中元素顺序进行反转
 */
- (void)revert;

/**
 将数组元素从一个位置移动另一个位置
 */

- (void)moveObjectAtIndex:(NSUInteger)fromIndex toIndex:(NSUInteger)toIndex;

/**
 将数组指定位置的元素移动到尾部
 */
- (void)moveObjectAtIndexToEnd:(NSUInteger)orginalIndex;

@end
