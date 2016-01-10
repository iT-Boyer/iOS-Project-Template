/*!
    MBTableViewArrayDataSource
    v 0.1

    Copyright © 2015 Beijing ZhiYun ZhiYuan Information Technology Co., Ltd.
    https://github.com/Chinamobo/iOS-Project-Template

    Apache License, Version 2.0
    http://www.apache.org/licenses/LICENSE-2.0
 */
#import "RFUI.h"
#import "MBEntityExchanging.h"

NS_ASSUME_NONNULL_BEGIN

@interface MBTableViewArrayDataSource : NSObject <
    RFInitializing,
    UITableViewDataSource
>
@property (nonatomic, nullable, weak) IBOutlet UITableView *tableView;

@property (nonatomic, strong) NSMutableArray *items;

- (id)itemAtIndexPath:(NSIndexPath *)indexPath;

- (nullable NSIndexPath *)indexPathForItem:(id)item;

@property (nonatomic, nullable, copy) NSString *_Nonnull (^cellIdentifierProvider)(__kindof MBTableViewArrayDataSource *_Nonnull dataSource, id _Nonnull item, NSIndexPath *_Nonnull indexPath);


@end

NS_ASSUME_NONNULL_END
