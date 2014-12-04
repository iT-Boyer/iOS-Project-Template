
#import "MBTableViewDataSource.h"
#import "MBEntityExchanging.h"

@implementation MBTableViewDataSource

- (void)onInit {
    [super onInit];
    if (!self.cellReuseIdentifier) {
        [self setCellReuseIdentifier:^NSString *(UITableView *tableView, NSIndexPath *indexPath, id item) {
            return @"Cell";
        }];
    }

    if (!self.configureCell) {
        [self setConfigureCell:^(UITableView *tableView, id<MBEntityExchanging> cell, NSIndexPath *indexPath, id item, BOOL offscreenRendering) {
            if ([cell respondsToSelector:@selector(setItem:)]) {
                [cell setItem:item];
            }
        }];
    }
}

- (void)fetchItemsFromViewController:(id)viewController nextPage:(BOOL)nextPage success:(void (^)(MBTableViewDataSource *, NSArray *))success completion:(void (^)(MBTableViewDataSource *))completion {
    @autoreleasepool {
        [super fetchItemsFromViewController:viewController nextPage:nextPage success:^(MBListDataSource *dateSource, NSArray *fetchedItems) {
            if (self.animationReload) {
                if (nextPage) {
                    NSMutableArray *indexPaths = [NSMutableArray arrayWithCapacity:fetchedItems.count];
                    NSUInteger rowCount = dateSource.items.count;
                    [fetchedItems enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                        [indexPaths addObject:[NSIndexPath indexPathForRow:rowCount - idx -1 inSection:0]];
                    }];
                    [self.tableView insertRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationAutomatic];
                }
                else {
                    if (self.animationReloadDisabledOnFirstPage) {
                        [self.tableView reloadData];
                    }
                    else {
                        [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationAutomatic];
                    }
                }
            }
            else {
                [self.tableView reloadData];
            }

            if (success) {
                success((id)dateSource, fetchedItems);
            }
        } completion:(id)completion];
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.items.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    id item = [self itemAtIndexPath:indexPath];
    NSString *reuseIdentifier = self.cellReuseIdentifier(tableView, indexPath, item);
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifier];
    RFAssert(cell, @"找不到 reuse identifier 为 %@ 的 cell", reuseIdentifier);
    self.configureCell(tableView, cell, indexPath, item, NO);
    return cell;
}

- (void)tableView:(UITableView *)tableView configureCell:(id)cell forIndexPath:(NSIndexPath *)indexPath offscreenRendering:(BOOL)isOffscreenRendering {
    self.configureCell(tableView, cell, indexPath, [self itemAtIndexPath:indexPath], isOffscreenRendering);
}

- (NSString *)tableView:(UITableView *)tableView cellReuseIdentifierForRowAtIndexPath:(NSIndexPath *)indexPath {
    return self.cellReuseIdentifier(tableView, indexPath, [self itemAtIndexPath:indexPath]);
}

@end
