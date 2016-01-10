/*!
    MBTableHeaderFooterView

    Copyright © 2014-2015 Beijing ZhiYun ZhiYuan Information Technology Co., Ltd.
    https://github.com/Chinamobo/iOS-Project-Template

    Apache License, Version 2.0
    http://www.apache.org/licenses/LICENSE-2.0
 */
#import "RFUI.h"
#import "RFFeatureSupport.h"

@interface MBTableHeaderFooterView : UIView <
    RFInitializing,
    RFOnlySupportLoadFromNib
>

@property (weak, nonatomic) IBOutlet UIView *contentView;

- (void)updateHeight;
- (void)updateHeightAnimated:(BOOL)animated;


- (void)setupAsHeaderViewToTableView:(UITableView *)tableView;
- (void)setupAsFooterViewToTableView:(UITableView *)tableView;
@end
