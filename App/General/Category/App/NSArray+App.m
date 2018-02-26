
#import "NSArray+App.h"

@implementation NSArray (App)

- (id)randomObject {
    NSUInteger count = self.count;
    if (!count) return nil;
    return self[arc4random() % count];
}

- (nonnull NSArray *)historyArrayWithNewItems:(nullable NSArray *)items limit:(NSUInteger)limit {
    NSMutableArray *history = [NSMutableArray arrayWithCapacity:limit];
    NSInteger count = 0;

    for (id item in items) {
        if (![history containsObject:item]) {
            [history addObject:item];
            count++;
        }
        if (count >= limit) {
            return history;
        }
    }

    for (id item in self) {
        if (![history containsObject:item]) {
            [history addObject:item];
            count++;
        }
        if (count >= limit) {
            return history;
        }
    }

    return history;
}

- (nonnull NSMutableArray *)rf_mapedArrayWithBlock:(id _Nullable (^_Nonnull)(id _Nonnull))block {
    NSMutableArray *map = [NSMutableArray arrayWithCapacity:self.count];
    [self enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        id value = block(obj);
        [map rf_addObject:value];
    }];
    return map;
}

- (NSArray *)arrayByRemovingObject:(id)anObject {
    if (![self containsObject:anObject]) {
        return self.copy;
    }
    NSMutableArray *newArr = self.mutableCopy;
    [newArr removeObject:anObject];
    return newArr.copy;
}

- (NSArray *)arrayByRemovingObjectsPassingTest:(BOOL (^_Nonnull)(id _Nonnull obj, NSUInteger idx, BOOL *_Nonnull stop))predicate {
    NSMutableArray *newArr = self.mutableCopy;
    [newArr removeObjectsPassingTest:predicate];
    return newArr;
}

- (BOOL)containsAnyObjectInArray:(nullable NSArray *)otherArray {
    for (id object in otherArray) {
        if ([self containsObject:object]) return YES;
    }
    return NO;
}

- (BOOL)isEqualToArrayIgnoringOrder:(NSArray *)otherArray {
    if (!otherArray) return NO;
    
    for (id object in self) {
        if (![otherArray containsObject:object]) {
            return NO;
        }
    }
    
    return YES;
}

@end


@implementation NSMutableArray (ZYAdd)

- (void)zy_replaceObjectAtIndex:(NSUInteger)index withObject:(id)anObject {
    if (index >= self.count || !anObject) return;
    [self replaceObjectAtIndex:index withObject:anObject];
}

- (void)removeObjectsNotInArray:(NSArray *)otherArray {
    [self removeObjectsPassingTest:^BOOL(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        return ![otherArray containsObject:obj];
    }];
}

- (void)revert {
    NSArray *revertedArr = self.reverseObjectEnumerator.allObjects;
    [self setArray:revertedArr];
}

- (void)moveObjectAtIndex:(NSUInteger)fromIndex toIndex:(NSUInteger)toIndex {
    id object = self[fromIndex];
    [self removeObjectAtIndex:fromIndex];
    [self insertObject:object atIndex:toIndex];
}

- (void)moveObjectAtIndexToEnd:(NSUInteger)orginalIndex {
    if (!self.count || orginalIndex >= self.count) return;
    [self moveObjectAtIndex:orginalIndex toIndex:self.count - 1];
}

@end


