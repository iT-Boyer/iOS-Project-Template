/*!
 MBAnalytics
 
 Copyright © 2018 RFUI.
 Copyright © 2015 Beijing ZhiYun ZhiYuan Technology Co., Ltd.
 https://github.com/BB9z/iOS-Project-Template
 
 Apache License, Version 2.0
 http://www.apache.org/licenses/LICENSE-2.0
 */

#import "Common.h"

NS_ASSUME_NONNULL_BEGIN

@class MBAnalyticsEvent;

/**
 Crashlytics 日志记录
 正常用 CLS_LOG() —— 会记录打印位置，MBCLog() 则不打印位置信息
 */
FOUNDATION_EXTERN void MBCLog(NSString *format, ...) NS_FORMAT_FUNCTION(1,2);

/**
 Answers 自定义事件参数备忘
 -----
 
 - 不能用 @"key": @(bool) 的方式统计 bool，但可以用 @"key" : bool? @"YES" : @"NO" 的方式；
 */
@interface MBAnalytics : NSObject

+ (void)setup;

//+ (void)startFabric;

#pragma mark Event

/**
 一般事件记录
 */
+ (void)logEventWithName:(NSString *)eventName attributes:(nullable NSDictionary<NSString *, id> *)attributes;

/**
 记录登录
 */
+ (void)logLoginWithMethod:(nullable NSString *)loginMethod success:(nullable NSNumber *)isSucceeded attributes:(nullable NSDictionary<NSString *, id> *)attributes;

/**
 记录错误
 */
+ (void)logError:(nullable NSError *)error withName:(NSString *)eventName attributes:(nullable NSDictionary<NSString *, id> *)attributes;

/**
 logError:withName:attributes: 记录的是自定义事件
 
 这个方法记录的是 No-Fatals error
 */
+ (void)recordError:(nonnull NSError *)error withAttributes:(nullable NSDictionary<NSString *, id> *)attributes;

/**
 记录评价
 
 @param contentID 可以是 NSNumber 或 NSString
 */
+ (void)logRating:(nullable NSNumber *)ratingOrNil contentName:(nullable NSString *)contentNameOrNil contentType:(nullable NSString *)contentTypeOrNil contentID:(nullable id)contentID customAttributes:(nullable NSDictionary<NSString *, id> *)customAttributesOrNil;

#pragma mark -

/**
 开始一个事件
 
 调用 endEvent: 来结束这个时间
 
 @return 创建的事件对象，startTime 已设置好，可以进行其他的设置
 */
+ (MBAnalyticsEvent *)startEvent:(NSString *)eventID;

/**
 结算并记录事件
 
 @param event 事件对象，没有 eventID 的对象会被忽略
 */
+ (void)endEvent:(MBAnalyticsEvent *)event;

/**
 页面记录
 
 会同时记录到友盟和 Fabric，Fabric 会带 duration 字段
 */
+ (void)beginLogPageWithName:(NSString *)pageName;
+ (void)endLogPageWithName:(NSString *)pageName attributes:(nullable NSDictionary<NSString *, id> *)attributes;

@end


@interface MBAnalyticsEvent : NSObject
@property (copy) NSString *eventID;
@property (nullable, copy) NSString *label DEPRECATED_ATTRIBUTE;
@property (nullable, copy) NSDictionary<NSString *, id> *attributes;

/**
 如果使用 startEvent:, endEvent: 可以不用手动设置时长
 
 如果设置了以设置时长为准
 */
@property NSTimeInterval duration;
@property (readonly) CFTimeInterval startTime;
@end


@interface UIViewController (MBAnalyticsPageName)
@property (nonatomic, nullable, readonly, copy) NSString *pageName;
@property (nonatomic, nullable, readonly, copy) NSDictionary *pageAttributes;

/// 视图自己统计页面
@property (readonly) BOOL pageEventManual;

/**
 控件调用该方法以实现自动记录，目前支持的控件有 ZYLayoutButton
 
 使用方法：
 
 一般是按钮在点击时，调用所属 view controller 的该方法。同时需要按钮上设置 mb_event 属性作为事件名，view controller 设置 mb_event 属性作为 module 名，这样统计的基本参数就全了。
 
 额外属性有多种方式补充，可以满足各种场景：
 - 首先，页面固定附加的参数，可以通过 view cotroller 实现 pageAttributes 来提供；
 - 其次，可以在设置控件时，直接把需要的参数挂到 mb_eventAttributes 属性上；
 - 再次，具体 vc 重写 MBAnalyticsCustomEventWithSender:attributes: 判断 sender 来调用，例：
 
 @code
 // in some vc
 
 - (void)MBAnalyticsCustomEventWithSender:(id)sender attributes:(NSDictionary *)attributes {
     // 根据场景判断需要附加什么参数
     if (sender == self.submitButton) {
         // 演示简单的重设了，正常可能需要跟传入的参数合并一下
         attributes = @{ @"foo": @"bar" };
     }
 
     // 调用父类完成后续自动处理
     [super MBAnalyticsCustomEventWithSender:sender attributes:attributes];
 }
 @endcode
 
 - 最后，就是在调用该方法时直接传递；
 - 这几种方法优先级依次递增，即后面的方式会覆盖前面的参数。
 
 */
- (void)MBAnalyticsCustomEventWithSender:(nonnull id)sender attributes:(nullable NSDictionary *)attributes;

@end


@interface NSObject (MBAnalyticsCustomEvent)
/// 为所有对象加一个事件名
@property (nonatomic, nullable, copy) IBInspectable NSString *mb_event;

/// 挂载的事件统计属性
@property (nonatomic, nullable) NSDictionary *mb_eventAttributes;

@end

extern NSString *const MBAnalyticsExitPageName;

NS_ASSUME_NONNULL_END
