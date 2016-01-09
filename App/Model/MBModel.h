/*!
    MBModel

    Copyright © 2015-2016 Beijing ZhiYun ZhiYuan Information Technology Co., Ltd.
    https://github.com/Chinamobo/iOS-Project-Template

    Apache License, Version 2.0
    http://www.apache.org/licenses/LICENSE-2.0
 */

#import "JSONModel.h"

#pragma mark - MBModel

/**
 默认属性全部可选
 */
@interface MBModel : JSONModel
@end

/**
 标记全部属性可选
 */
#define MBModelOptionalProperties \
    + (BOOL)propertyIsOptional:(NSString *)propertyName {\
        return YES;\
    }

/**
 定义忽略规则
 
 如果属性已经用 <Ignore> 标记了，可以不定义在这里
 */
#define MBModelIgnoreProperties(CLASS, ...) \
    + (BOOL)propertyIsIgnored:(NSString *)propertyName {\
        static NSArray *map;\
        if (!map) {\
            CLASS *this;\
            map = @[\
                    metamacro_foreach_cxt(_mbmodel_makeArray, , , __VA_ARGS__)\
                    ];\
        }\
        if ([map containsObject:propertyName]) {\
            return YES;\
        }\
        return [super propertyIsIgnored:propertyName];\
    }

#define _mbmodel_makeArray(INDEX, CONTEXT, VAR) \
    @keypath(this, VAR),


#pragma mark 忽略

@protocol MBModel <NSObject>

/// 标记这个对象在处理时应该被忽略
- (BOOL)ignored;
@end

#pragma mark - 完备性

/**
 完备性支持
 */
@protocol MBModelCompleteness <NSObject>
@required
/// 信息不完整标记，需要获取详情
@property (strong, nonatomic) NSNumber<Ignore> *incompletion;

@end


#pragma mark - 更新通知

/**
 UI 更新支持
 */
@protocol MBModelUpdating <NSObject>
@optional

@property (readonly, nonatomic) NSHashTable<Ignore> *displayers;

- (void)addDisplayer:(id)displayer;
- (void)removeDisplayer:(id)displayer;

@end

/**
 displayers 生成方法
 */
#define MBModelUpdatingImplementation \
    - (NSHashTable<Ignore> *)displayers {\
        if (!_displayers) {\
            _displayers = [NSHashTable weakObjectsHashTable];\
        }\
        return _displayers;\
    }\
    - (void)addDisplayer:(id)displayer {\
        [self.displayers addObject:displayer];\
    }\
    - (void)removeDisplayer:(id)displayer {\
        [self.displayers removeObject:displayer];\
    }

/**
 通知生成方法
 */
#define MBModelStatusUpdatingMethod(METHODNAME, PROTOCOL, PROTOCOL_SELECTOR) \
    - (void)METHODNAME {\
        NSArray *all = [self.displayers allObjects];\
        for (id<PROTOCOL> displayer in all) {\
            if ([displayer respondsToSelector:@selector(PROTOCOL_SELECTOR:)]) {\
                [displayer PROTOCOL_SELECTOR:self];\
            }\
        }\
    }

#pragma mark - UID

/**

 */
@protocol MBModelUID <NSObject>
@property (assign, nonatomic) int uid;
@end

/**
 是否相同

 uid 整形
 */
#define MBModelUIDEqual \
    - (BOOL)isEqual:(id)other {\
        if (other == self) {\
            return YES;\
        }\
        else if (![other isMemberOfClass:[self class]]) {\
            return NO;\
        }\
        else {\
            if (self.uid == [(id<MBModelUID>)other uid]) {\
                return YES;\
            }\
        }\
        return NO;\
    }\
    - (NSUInteger)hash {\
        return self.uid;\
    }


#pragma mark - 其他

/**
 NSDate 的什么也没重写的子类，为了支持接口中的毫秒格式
 */
@interface NSMilliDate : NSDate
@end
