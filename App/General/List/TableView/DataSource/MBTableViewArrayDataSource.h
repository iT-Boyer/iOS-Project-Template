/*!
    MBTableViewArrayDataSource
    v 0.1

    Copyright © 2015 Beijing ZhiYun ZhiYuan Information Technology Co., Ltd.
    https://github.com/Chinamobo/iOS-Project-Template

    Apache License, Version 2.0
    http://www.apache.org/licenses/LICENSE-2.0
 */

#import "Common.h"

NS_ASSUME_NONNULL_BEGIN

/**
 数组作为数据源的 table view data source
 */
@interface MBTableViewArrayDataSource : NSObject <
    RFInitializing,
    UITableViewDataSource
>
@property (nonatomic, nullable, weak) IBOutlet UITableView *tableView;

@property (nonatomic, strong) NSMutableArray *items;

- (id)itemAtIndexPath:(NSIndexPath *)indexPath;

- (nullable NSIndexPath *)indexPathForItem:(id)item;

@property (nonatomic, nullable, copy) NSString *_Nonnull (^cellIdentifierProvider)(__kindof MBTableViewArrayDataSource *_Nonnull dataSource, id _Nonnull item, NSIndexPath *_Nonnull indexPath);

#pragma mark - List operation
// 这些操作会更新单元对应的数据

- (void)deleteRowAtIndexPath:(nonnull NSIndexPath *)indexPath withRowAnimation:(UITableViewRowAnimation)animation;

/**
 @param indexPath 如果不合法会忽略
 @param newIndexPath 如果越界会崩溃
 */
- (void)moveRowAtIndexPath:(NSIndexPath *)indexPath toIndexPath:(NSIndexPath *)newIndexPath;

@end

NS_ASSUME_NONNULL_END
