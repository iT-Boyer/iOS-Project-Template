/*!
    MBFormSelectButton
    v 2.0

    Copyright © 2014 Beijing ZhiYun ZhiYuan Information Technology Co., Ltd.
    Copyright © 2014 Chinamobo Co., Ltd.
    https://github.com/Chinamobo/iOS-Project-Template

    Apache License, Version 2.0
    http://www.apache.org/licenses/LICENSE-2.0
 */
#import "MBButton.h"

/**
 
 */
@interface MBFormSelectButton : MBButton

@property (strong, nonatomic) id selectedVaule;

/// 占位符文本，默认使用 nib 中定义的 normal 文本
@property (copy, nonatomic) NSString *placeHolder;

/// 修改该属性决定如何展示数值
/// 未设置则显示 value 的 description
@property (copy, nonatomic) NSString *(^valueDisplayString)(id value);

@end
