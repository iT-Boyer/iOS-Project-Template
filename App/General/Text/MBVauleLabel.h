/*!
    MBRefreshFooterView

    Copyright © 2015-2016 Beijing ZhiYun ZhiYuan Information Technology Co., Ltd.
    https://github.com/BB9z/iOS-Project-Template

    Apache License, Version 2.0
    http://www.apache.org/licenses/LICENSE-2.0
 */

#import "Common.h"

/**
 设置
 */
@interface MBVauleLabel : UILabel
@property (strong, nonatomic) id value;

/// 重写或设置 block 改变展示方式
- (NSString *)displayStringForVaule:(id)value;
@property (copy, nonatomic) NSString* (^vauleFormatBlock)(MBVauleLabel *label, id value);
@end


@interface MBVauleAttributedLabel : UILabel <
    RFInitializing
>
@property (strong, nonatomic) id value;

/// 空值时显示的文本
@property (nonatomic, copy) IBInspectable NSString *nullValueDisplayString;

/// 空数字显示空值文本
@property (nonatomic) IBInspectable BOOL treatZeroNumberAsNull;

/// awakeFromNib 时设置，代码创建需要手动赋值
@property (nonatomic, strong) NSAttributedString *attributedFormatString;

/// 重写或设置 block 改变展示方式
- (NSAttributedString *)displayAttributedStringForVaule:(id)value;
@property (copy, nonatomic) NSAttributedString* (^vauleFormatBlock)(MBVauleAttributedLabel *label, id value);
@end


/**
 hh:mm:ss or mm:ss
 */
@interface ZYDurationLabel : MBVauleLabel
/// YES 时，如果没有小时，则以 mm:ss 格式显示
@property (getter=isHourOptional) IBInspectable BOOL hourOptional;
@end

/**
 999m or 3.21km
 */
@interface ZYDistanceLabel : MBVauleAttributedLabel
@property (nonatomic, copy) NSDictionary *numberAttributes;
@property (nonatomic, copy) NSDictionary *unitAttributes;

/// 开启时，不足 1000m 显示 xxm
@property (nonatomic) IBInspectable BOOL autoUnit;
@end
