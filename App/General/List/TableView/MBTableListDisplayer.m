
#import "MBTableListDisplayer.h"
#import "API.h"

@interface MBTableListDisplayer ()
@end

@implementation MBTableListDisplayer
RFInitializingRootForUIViewController
@dynamic tableView;

- (void)onInit {
}

- (void)afterInit {
}

- (void)dealloc {
    self.tableView.delegate = nil;
    self.tableView.dataSource = nil;
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

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    id dvc = segue.destinationViewController;
    if (![dvc respondsToSelector:@selector(setItem:)]) return;

    id item;
    if ([sender respondsToSelector:@selector(item)]) {
        item = [(id<MBEntityExchanging>)sender item];
    }
    else {
        item = [UITableViewCell itemFromSender:sender];
    }

    if (!item && [self respondsToSelector:@selector(item)]) {
        item = [(id<MBEntityExchanging>)self item];
    }
    [dvc setItem:item];
}

#pragma mark - MBEntityListDisplaying

- (id)listView {
    return self.tableView;
}

- (void)refresh {
    [self.tableView.pullToFetchController triggerHeaderProcess];
}

@end


@implementation MBTableListController
RFUIInterfaceOrientationSupportDefault

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

#pragma mark - MBEntityListDisplaying

- (UITableView *)listView {
    return self.listDisplayer.listView;
}

- (void)refresh {
    [self.listDisplayer refresh];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    id dvc = segue.destinationViewController;
    if (![dvc respondsToSelector:@selector(setItem:)]) return;

    id item;
    if ([sender respondsToSelector:@selector(item)]) {
        item = [(id<MBEntityExchanging>)sender item];
    }
    else {
        item = [UITableViewCell itemFromSender:sender];
    }

    if (!item && [self respondsToSelector:@selector(item)]) {
        item = [(id<MBEntityExchanging>)self item];
    }
    [dvc setItem:item];
}

@end
