
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

#pragma mark - List operation

- (void)deleteRowAtIndexPath:(NSIndexPath *)indexPath withRowAnimation:(UITableViewRowAnimation)animation {
    if (!indexPath) return;

    NSInteger row = indexPath.row;
    NSMutableArray *items = self.items;
    if (row == NSNotFound || row >= items.count || row < 0) {
        return;
    }

    [items removeObjectAtIndex:row];
    [self.tableView deleteRowsAtIndexPaths:@[ indexPath ] withRowAnimation:animation];
}

- (void)moveRowAtIndexPath:(NSIndexPath *)indexPath toIndexPath:(NSIndexPath *)newIndexPath {
    if (!indexPath || !newIndexPath) return;

    NSMutableArray *items = self.items;
    id item = [items rf_objectAtIndex:indexPath.row];
    if (!item) return;

    [items removeObjectAtIndex:indexPath.row];
    [items insertObject:item atIndex:newIndexPath.row];
    [self.tableView moveRowAtIndexPath:indexPath toIndexPath:newIndexPath];
}

@end
