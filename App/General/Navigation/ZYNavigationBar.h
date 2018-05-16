/*!
 ZYNavigationBar
 
 Copyright © 2018 RFUI.
 Copyright © 2015 Beijing ZhiYun ZhiYuan Technology Co., Ltd.
 https://github.com/BB9z/iOS-Project-Template
 
 Apache License, Version 2.0
 http://www.apache.org/licenses/LICENSE-2.0
 */

#import "Common.h"

@interface ZYNavigationBar : UINavigationBar

// 原生的导航位置/平铺模式不好控制，如果不能轻易调好，需要很多奇怪的组合的话，往后系统改行为就坑了
// 不如写个自己的便于控制
@property (nonatomic, nullable, weak) UIImageView *ZYShadowImageView;
@end
