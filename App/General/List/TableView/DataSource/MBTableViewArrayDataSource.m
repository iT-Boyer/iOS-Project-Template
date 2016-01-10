
#import "MBTableViewArrayDataSource.h"

@interface MBTableViewArrayDataSource ()
@end

@implementation MBTableViewArrayDataSource
RFInitializingRootForNSObject

- (void)onInit {

}

- (void)afterInit {
    // Nothing
}

- (nonnull id)itemAtIndexPath:(nonnull NSIndexPath *)indexPath {
    NSParameterAssert(indexPath);
    return self.items[indexPath.row];
}

- (nullable NSIndexPath *)indexPathForItem:(nonnull id)item {
    NSInteger idx = [self.items indexOfObject:item];
    if (idx != NSNotFound) {
        return [NSIndexPath indexPathForRow:idx inSection:0];
    }
    return nil;
}

- (void)setItems:(NSMutableArray *)items {
    _items = items;
    [self.tableView reloadData];
}

- (nonnull NSString *)cellIdentifierAtIndexPath:(nonnull NSIndexPath *)indexPath {
    if (self.cellIdentifierProvider) {
        return self.cellIdentifierProvider(self, [self itemAtIndexPath:indexPath], indexPath);
    }
    return @"Cell";
}

#pragma mark - 

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.items.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell<MBSenderEntityExchanging> *cell = [tableView dequeueReusableCellWithIdentifier:[self cellIdentifierAtIndexPath:indexPath] forIndexPath:indexPath];
    cell.item = [self itemAtIndexPath:indexPath];
    return cell;
}

@end
