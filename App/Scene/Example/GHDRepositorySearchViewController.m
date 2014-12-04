
#import "GHDRepositorySearchViewController.h"
#import "GitHubDemoEntities.h"
#import "MBAutoSearchBar.h"
#import "API.h"

@interface GHDRepositorySearchViewController () <
    UITableViewDelegate
>
@property (assign, nonatomic) BOOL viewLoadded;
@end

@implementation GHDRepositorySearchViewController
RFUIInterfaceOrientationSupportDefault

- (void)viewDidLoad {
    [super viewDidLoad];

    MBTableView *tb = self.tableView;
    MBTableViewDataSource *ds = tb.dataSource;
    ds.fetchAPIName = @"Demo";
    ds.pageSizeParameterName = @"size";
    ds.pageSize = 5;
    [ds setCellReuseIdentifier:^NSString *(UITableView *tableView, NSIndexPath *indexPath, id item) {
        return @metamacro_stringify(GHDRepositoryCell);
    }];

    MBRefreshFooterView *footer = (id)tb.pullToFetchController.footerContainer;
    footer.emptyLabel.text = @"没有结果";

    @weakify(tb, ds);
    [self.searchBar setDoSearch:^(MBAutoSearchBar *searchBar, NSString *keywords) {
        @strongify(tb, ds);
        ds.fetchParameters = [@{ @"keywords" : keywords?: @"" } mutableCopy];
        [tb.pullToFetchController triggerHeaderProcess];
    }];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];

    // 默认上来搜 iOS
    if (!self.viewLoadded) {
        [self.searchBar doSearchWithKeyword:@"iOS" force:NO];
    }
    self.viewLoadded = YES;
}

- (void)tableView:(MBTableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    GHDRepositoryEntity *item = [tableView.dataSource itemAtIndexPath:indexPath];
    [[UIApplication sharedApplication] openURL:item.pageURL];
}

@end

@implementation GHDRepositoryCell

- (void)setItem:(GHDRepositoryEntity *)item {
    _item = item;

    self.nameLabel.text = item.name;
    self.descriptionLabel.text = item.descriptionText;
}

@end
