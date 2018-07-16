/*!
 MBTableViewArrayDataSource
 
 Copyright © 2018 RFUI.
 Copyright © 2015-2016 Beijing ZhiYun ZhiYuan Information Technology Co., Ltd.
 https://github.com/BB9z/iOS-Project-Template
 
 Apache License, Version 2.0
 http://www.apache.org/licenses/LICENSE-2.0
 */
#import <MBAppKit/MBAppKit.h>

/**
 数组作为数据源的 table view data source
 */
@interface MBTableViewArrayDataSource : NSObject <
    RFInitializing,
    UITableViewDataSource
>
@property (weak, nullable, nonatomic) IBOutlet UITableView *tableView;

@property (nullable, nonatomic) NSMutableArray *items;

- (nonnull id)itemAtIndexPath:(nonnull NSIndexPath *)indexPath;

- (nullable NSIndexPath *)indexPathForItem:(nonnull id)item;

@property (nullable) NSString *__nonnull (^cellIdentifierProvider)(__kindof MBTableViewArrayDataSource *__nonnull dataSource, id __nonnull item, NSIndexPath *__nonnull indexPath);

#pragma mark - List operation
// 这些操作会更新单元对应的数据

- (void)deleteRowAtIndexPath:(nonnull NSIndexPath *)indexPath withRowAnimation:(UITableViewRowAnimation)animation;

/**
 @param indexPath 如果不合法会忽略
 @param newIndexPath 如果越界会崩溃
 */
- (void)moveRowAtIndexPath:(nullable NSIndexPath *)indexPath toIndexPath:(nullable NSIndexPath *)newIndexPath;

@end
