//
//  MBOptionSwitch.h
//  Feel
//
//  Created by BB9z on 10/17/15.
//  Copyright © 2015 Beijing ZhiYun ZhiYuan Technology Co., Ltd. All rights reserved.
//

#import "Common.h"

/**
 自动从 NSUserDefaults 读取设置并可自动更新首选项的 UISwitch
 */
@interface MBOptionSwitch : UISwitch <
    RFInitializing
>
/// 设定为 key 值，不是属性名
@property (nonatomic, copy) IBInspectable NSString *optionKey;

/// 选项是从应用共享配置还是用户个人配置读取，默认是用户配置
@property (nonatomic) IBInspectable BOOL sharedPreferences;

/// 显示与存储值是相反的
@property (nonatomic) IBInspectable BOOL reversed;
@end
