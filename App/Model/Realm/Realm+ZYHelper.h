//
//  RLMRealm+ZYHelper.h
//  Feel
//
//  Created by BB9z on 7/28/16.
//  Copyright © 2016 Beijing ZhiYun ZhiYuan Technology Co., Ltd. All rights reserved.
//

#import <Realm/Realm.h>

@interface RLMObject (ZYHelper)

/**
 从私有用户数据库查询

 @warning 这个查询现在支持从非主线程查询，但是在非主线程查询到的 RLMResults 不会自动更新，
 比如方法返回后，在主线程更新了数据库，这个结果仍然是旧的。
 */
+ (nonnull RLMResults *)resultsWithPredicateFormat:(nonnull NSString *)predicateFormat, ...;

@end
