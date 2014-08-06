
#import "MBFormSelectListViewController.h"
#import "RFTimer.h"
#import "API.h"

@interface MBFormSelectListViewController () {
    BOOL _needsUpdateUIForItem;
}
@end

@implementation MBFormSelectListViewController
RFUIInterfaceOrientationSupportDefault

#pragma mark - Items

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self updateUIForItemIfNeeded];
}

- (void)setItems:(NSArray *)items {
    if (_items != items) {
        _items = items;

        if (self.isViewLoaded) {
            [self updateUIForItem];
        }
        else {
            [self setNeedsUpdateUIWithSegue:nil];
        }
    }
}

- (void)updateUIForItem {
    _needsUpdateUIForItem = NO;

    NSArray *selectedItems = self.selectedItems;
    UITableView *tableView = self.tableView;
    [tableView reloadData];

    for (id item in selectedItems) {
        NSUInteger idx = [self.filteredItems indexOfObject:item];
        if (idx == NSNotFound) {
            continue;
        }

        [tableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:idx inSection:0] animated:NO scrollPosition:UITableViewScrollPositionNone];
    }
}

- (IBAction)setNeedsUpdateUIWithSegue:(UIStoryboardSegue *)sender {
    _needsUpdateUIForItem = YES;
}

- (void)updateUIForItemIfNeeded {
    if (_needsUpdateUIForItem) {
        [self updateUIForItem];
    }
}

#pragma mark - Return

- (IBAction)onSaveButtonTapped:(id)sender {
    [self performResultCallBack];
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.returnWhenSelected) {
        [self performResultCallBack];
        [self.navigationController popViewControllerAnimated:YES];
    }
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    if (!self.requireUserPressSave && !self.returnWhenSelected) {
        [self performResultCallBack];
    }
}

- (void)performResultCallBack {
    NSArray *indexPaths = [self.tableView indexPathsForSelectedRows];
    NSMutableIndexSet *indexSet = [[NSMutableIndexSet alloc] init];
    for (NSIndexPath *indexPath in indexPaths) {
        [indexSet addIndex:indexPath.row];
    }
    NSArray *selectedItems = [self.filteredItems objectsAtIndexes:indexSet];

    if (self.didEndSelection) {
        self.didEndSelection(self, selectedItems);
    }
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.filteredItems.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    MBFormSelectTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
    RFAssert([cell isKindOfClass:[MBFormSelectTableViewCell class]], @"MBFormSelectListViewController 的 cell 必须是 MBFormSelectTableViewCell");
    cell.value = self.filteredItems[indexPath.row];
    return cell;
}

#pragma mark - 筛选基础支持

- (NSArray *)filteredItems {
    return _filteredItems?: self.items;
}

#pragma mark - Search

- (RFTimer *)autoSearchTimer {
    if (!_autoSearchTimer) {
        _autoSearchTimer = [RFTimer new];
        _autoSearchTimer.timeInterval = 0.6;

        @weakify(self);
        [_autoSearchTimer setFireBlock:^(RFTimer *timer, NSUInteger repeatCount) {
            @strongify(self);
            [self autoSearch];
        }];
    }
    return _autoSearchTimer;
}

- (void)autoSearch {
    self.autoSearchTimer.suspended = YES;

    NSString *keyword = self.searchBar.text;
    _douto(keyword)

    if (![keyword isEqualToString:self.searchingKeyword]) {
        [self doSearchWithKeyword:keyword];
    }
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
    self.autoSearchTimer.suspended = YES;
    self.autoSearchTimer.suspended = NO;
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    [self autoSearch];
}

- (void)doSearchWithKeyword:(NSString *)keyword {
    if (![self.searchingKeyword isEqualToString:keyword]) {
        [API cancelOperationsWithViewController:self];
    }
    self.searchingKeyword = keyword;

    // 请求并更新结果
}

@end

@implementation MBFormSelectTableViewCell

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    self.accessoryType = selected? UITableViewCellAccessoryCheckmark : UITableViewCellAccessoryNone;
    [super setSelected:selected animated:animated];
}

- (void)setValue:(id)value {
    _value = value;
    [self displayForValue:value];
}

- (void)displayForValue:(id)value {
    self.valueDisplayLabel.text = [NSString stringWithFormat:@"%@", value];
}

@end
