
#import "MBTableListDisplayer.h"
#import "API.h"

@interface MBTableListDisplayer ()
@end

@implementation MBTableListDisplayer
RFInitializingRootForUIViewController
MBEntityExchangingPrepareForTableViewSegue
@dynamic tableView;

- (void)onInit {
}

- (void)afterInit {
}

- (void)dealloc {
    if (self.viewLoaded) {
        self.tableView.delegate = nil;
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];

    MBTableViewDataSource *ds = self.tableView.dataSource;
    self.dataSource = ds;
    if (self.APIName) {
        ds.fetchAPIName = self.APIName;
    }
    [self setupDataSource:ds];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    if (self.clearsSelectionOnViewWillAppear) {
        [self.listView deselectRows:animated];
    }
}

- (void)setupDataSource:(MBTableViewDataSource *)ds {
}

- (void)setAPIName:(NSString *)APIName {
    _APIName = APIName;
    self.dataSource.fetchAPIName = APIName;
}

- (NSString *)APIGroupIdentifier {
    return self.parentViewController.APIGroupIdentifier;
}

#pragma mark - MBGeneralListDisplaying

- (id)listView {
    return self.tableView;
}

- (void)refresh {
    [self.tableView.pullToFetchController triggerHeaderProcess];
}

@end


@implementation MBTableListController
MBEntityExchangingPrepareForTableViewSegue

- (void)viewDidLoad {
    [super viewDidLoad];

    MBTableListDisplayer *dc = self.childViewControllers.lastObject;
    self.listDisplayer = dc;

    if (self.APIName) {
        dc.dataSource.fetchAPIName = self.APIName;
    }
    NSString *ci = self.cellIdentifier;
    if (ci) {
        [dc.dataSource setCellReuseIdentifier:^NSString *(UITableView *tb, NSIndexPath *ip, id item) {
            return ci;
        }];
    }

    [self setupDataSource:dc.dataSource];
    if (!self.disableAutoRefreshAfterViewLoadded) {
        [dc refresh];
        [dc.listView setAutoFetchWhenMoveToWindow:YES];
    }
}

- (void)setupDataSource:(MBTableViewDataSource *)ds {
}

- (MBTableViewDataSource *)dataSource {
    return self.listDisplayer.dataSource;
}

#pragma mark - MBGeneralListDisplaying

- (UITableView *)listView {
    return self.listDisplayer.listView;
}

- (void)refresh {
    [self.listDisplayer refresh];
}

@end
