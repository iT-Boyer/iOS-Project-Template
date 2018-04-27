/*!
 MBLoadButton
 
 Copyright © 2018 RFUI.
 Copyright © 2014 Beijing ZhiYun ZhiYuan Technology Co., Ltd.
 https://github.com/BB9z/iOS-Project-Template
 
 Apache License, Version 2.0
 http://www.apache.org/licenses/LICENSE-2.0
 */
#import "Common.h"
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
