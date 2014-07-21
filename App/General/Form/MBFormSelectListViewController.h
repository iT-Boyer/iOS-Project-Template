/*!
    MBFormSelectListViewController
    v 1.1

    Copyright © 2014 Chinamobo Co., Ltd.
    https://github.com/Chinamobo/iOS-Project-Template

    Apache License, Version 2.0
    http://www.apache.org/licenses/LICENSE-2.0
 */
#import <UIKit/UIKit.h>

/**
 选择列表控制器
 
 使用：
 
 设置 items 和 selectedItems 属性，选择结果会通过 didEndSelection 的 block 返回，选项的展示由 MBFormSelectTableViewCell 控制

 是否支持多选可在 Storyboard 中设置 allowsMultipleSelection 属性
 
 如果需要异步设置数据源（如从网络获取数据），子类该类后设置 items 即可
 */
@interface MBFormSelectListViewController : UITableViewController

#pragma mark - 数据源

/// 设置该属性决定列表中有哪些选项
@property (strong, nonatomic) NSArray *items;

/// 该属性用于设置已选项，数组中的元素是 items 中已选择的对象
/// 不会随 tableView 选择而变化
@property (copy, nonatomic) NSArray *selectedItems;

#pragma mark - 选择回调

/// 选择结果的回调
@property (copy, nonatomic) void (^didEndSelection)(id listController, NSArray *selectedItems);

#pragma mark - 返回控制

/**
 选中任一选项自动返回
 
 默认 NO
 */
@property (assign, nonatomic) BOOL returnWhenSelected;

/// 需要手动按保存才能改变选择结果
/// 默认 NO，当 viewWillDisappear 时自动返回新的选择结果
@property (assign, nonatomic) BOOL requireUserPressSave;

/// 当用户需要手动保存时，需要把该方法连接到保存按钮上
- (IBAction)onSaveButtonTapped:(id)sender;

@end

@interface MBFormSelectTableViewCell : UITableViewCell
@property (strong, nonatomic) id value;
@property (weak, nonatomic) IBOutlet UILabel *valueDisplayLabel;

/// 子类重写这个方法决定如何展示数值
/// 默认实现显示 value 的 description
- (void)displayForValue:(id)value;

@end
