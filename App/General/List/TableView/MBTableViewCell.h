/*!
    MBTableViewCell

    Copyright © 2014-2015 Beijing ZhiYun ZhiYuan Information Technology Co., Ltd.
    https://github.com/Chinamobo/iOS-Project-Template

    Apache License, Version 2.0
    http://www.apache.org/licenses/LICENSE-2.0
 */

#import "Common.h"

@interface MBTableViewCell : UITableViewCell <
    MBSenderEntityExchanging
>
/// 修改
@property (nonatomic) IBInspectable BOOL selectedBackgroundEnable;
@property (strong, nonatomic) id item;
- (void)setItem:(id)item offscreenRendering:(BOOL)offscreenRendering;
+ (CGFloat)heightForItem:(id)item width:(CGFloat)width;

/// 默认返回类名
+ (NSString *)reuseIdentifierForItem:(id)item;

@property (strong, nonatomic) NSIndexPath *indexPath;

/**
 协议方法，tableView:didSelectRowAtIndexPath: 时尝试执行这个方法

 默认什么也不做
 */
- (void)onCellSelected;
@end
