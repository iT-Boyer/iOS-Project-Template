/*!
 UIKit+App

 Copyright © 2016 Beijing ZhiYun ZhiYuan Technology Co., Ltd. All rights reserved.
 https://github.com/zhiyun168/Feel-iOS
 */

#import "UIKit+App.h"

/// 全局颜色十六进制色值
extern int const UIColorGlobalTintColorHex;

@interface UIColor (App)

+ (nonnull UIColor *)globalTintColor;
+ (nonnull UIColor *)globalHighlightedTintColor;
+ (nonnull UIColor *)globalDisabledTintColor;

/// 标题颜色 #535353
+ (nonnull UIColor *)globalTitleTextColor;
/// 正文颜色 #5E6066
+ (nonnull UIColor *)globalBodyTextColor;
/// 描述文本颜色 #9B9B9B
+ (nonnull UIColor *)globalDetialTextColor;

/// 同 globalTitleTextColor
+ (nonnull UIColor *)globalTextColor;
/// 占位符文本颜色
+ (nonnull UIColor *)globalPlaceholderTextColor;

/// 最深的背景色 #222
+ (nonnull UIColor *)globalDarkBackgroundColor;
/// 最浅的背景色 #F5F5F5
+ (nonnull UIColor *)globalLightBackgroundColor;
/// 页面背景色全部变为 #F0F4F8
+ (nonnull UIColor *)globalPageBackgroundColor;
/// 默认 cell 点击时的高亮色
+ (nonnull UIColor *)globalCellSelectionColor;

/// 阴影颜色 30% #000
+ (nonnull UIColor *)globalShadowColor;
/// 黑色半透明遮罩
+ (nonnull UIColor *)globalDarkMaskColor;

/// 图像默认占位背景色
+ (nonnull UIColor *)globalImageViewBackgroundColor;

/// 分割线颜色，#DDD
+ (nonnull UIColor *)globalSeparateLineColor;

/// #CCC
+ (nonnull UIColor *)globalLightGrayColor;
/// #999
+ (nonnull UIColor *)globalGrayColor;
/// #666
+ (nonnull UIColor *)globalDarkGrayColor;

/// 错误红
+ (nonnull UIColor *)globalErrorRead;

/// 睡眠主题紫
+ (nonnull UIColor *)globalSleepPurple;

/// 男性蓝
+ (nonnull UIColor *)globalMaleColor;
/// 女性粉
+ (nonnull UIColor *)globalFemaleColor;

// 健康计划项

/// 历史或未来检测项主题色
+ (nonnull UIColor *)scheduleDisabledThemeColor;
/// 心情检测项默认主题色
+ (nonnull UIColor *)scheduleMoodThemeColor;
/// 跑步检测项默认主题色
+ (nonnull UIColor *)scheduleRuntrackThemeColor;
/// plank 检测项默认主题色
+ (nonnull UIColor *)schedulePlankThemeColor;
/// 体重检测项默认主题色
+ (nonnull UIColor *)scheduleWeightThemeColor;
/// 心率检测项默认主题色
+ (nonnull UIColor *)scheduleHeartBeatThemeColor;
/// 睡眠检测项默认主题色
+ (nonnull UIColor *)scheduleSleepThemeColor;
///计步类型进度条的蓝色
+ (nonnull UIColor *)pedometerProgressTintColor;
///卡路里摄入未完成
+ (nonnull UIColor *)calorieIntakeColor;
///卡路里摄入超出
+ (nonnull UIColor *)calorieOverflowColor;
///咨询按钮阴影颜色
+ (nonnull UIColor *)goalConsultShadowColor;

///优惠券红色
+ (nonnull UIColor *)goalCouponRedColor;
///优惠券橙色
+ (nonnull UIColor *)goalCouponOrgangeColor;

#pragma mark -

/// 比当前颜色浅一些的颜色
- (nonnull UIColor *)rf_lighterColor;

/// 比当前颜色深一些的颜色
- (nonnull UIColor *)rf_darkerColor;

@end
