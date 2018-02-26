//
//  MBLoadButton.h
//  Feel
//
//  Created by BB9z on 11/5/14.
//  Copyright (c) 2014 Beijing ZhiYun ZhiYuan Information Technology Co., Ltd. All rights reserved.
//

#import "MBButton.h"

/**
 加载时 enabled 状态变为 NO，加载结束时恢复；加载失败时状态变为 selected
 
 跟 RFRefreshButton 类似，加载状态通过观察属性的方式自动设置
 */
@interface MBLoadButton : MBButton

@property (nonatomic) IBInspectable BOOL hidesWhenComplation;

- (void)setLoadding:(BOOL)loadding;
- (void)setSuccess:(BOOL)success;

#pragma mark - Auto update statue
@property (readonly, getter = isObserving, nonatomic) BOOL observing;
@property (weak, readonly, nonatomic) id observeTarget;
@property (copy, readonly, nonatomic) NSString *observeKeypath;

/**
 @param target Must not be nil.
 @param keypath Must not be nil.
 @param ifProccessingBlock Return `YES` if the observed target is proccessing. This parameter may be nil.
 */
- (void)observeTarget:(id)target forKeyPath:(NSString *)keypath evaluateBlock:(BOOL (^)(id evaluatedVaule))ifProccessingBlock;
- (void)stopObserve;
@end
