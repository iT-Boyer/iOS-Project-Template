
#import "MBTabController.h"
#import "API.h"
#import "MBAnalytics.h"
#import "MBListDataSource.h"
#import "MBNavigationController.h"
#import "MBTabControl.h"
#import "MBTableListDisplayer.h"

@interface MBTabController ()
@property (nonatomic, strong) NSString *pageAPIGroupIdentifier;
@end

@implementation MBTabController

- (void)onInit {
    [super onInit];
    self.delegate = self;
}

- (void)dealloc {
    self.pageAPIGroupIdentifier = nil;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tabControl.selectionNoticeOnlySendWhenButtonTapped = YES;
    self.pageViewController.APIGroupIdentifier = self.APIGroupIdentifier;
}

- (BOOL)pageEventManual {
    return YES;
}

- (BOOL)manageAPIGroupIdentifierManually {
    return YES;
}

- (void)setPageAPIGroupIdentifier:(NSString *)pageAPIGroupIdentifier {
    if ([_pageAPIGroupIdentifier isEqualToString:pageAPIGroupIdentifier]) return;
    if (_pageAPIGroupIdentifier) {
        [[API sharedInstance] cancelOperationsWithGroupIdentifier:_pageAPIGroupIdentifier];
    }
    _pageAPIGroupIdentifier = pageAPIGroupIdentifier;
}

- (IBAction)onTabChanged:(MBTabControl *)sender {
    self.isTapTabControlSwichPage = YES;
    NSUInteger index = sender.selectIndex;
    UIViewController *vc = [self viewControllerAtIndex:index];
    [self willSelectViewController:vc atIndex:index];

    @weakify(self);
    [self setSelectedIndex:index animated:YES completion:^(BOOL finished) {
        @strongify(self);
        [self didSelectViewController:vc atIndex:index];
        [self updateListWhenSelectedIndexChanged];
        self.isTapTabControlSwichPage = NO;
    }];
}

- (void)RFTabController:(RFTabController *)tabController willSelectViewController:(UIViewController *)viewController atIndex:(NSUInteger)index {
    self.isTapTabControlSwichPage = NO;
    [self willSelectViewController:viewController atIndex:index];
}

- (void)RFTabController:(RFTabController *)tabController didSelectViewController:(UIViewController *)viewController atIndex:(NSUInteger)index {
    self.tabControl.selectIndex = index;
    [self updateListWhenSelectedIndexChanged];
    [self didSelectViewController:viewController atIndex:index];
}

- (void)willSelectViewController:(UIViewController *)viewController atIndex:(NSUInteger)index {

}

- (void)didSelectViewController:(UIViewController *)viewController atIndex:(NSUInteger)index {

}

- (void)updateListWhenSelectedIndexChanged {
    NSUInteger index = self.selectedIndex;
    [self.viewControllers enumerateObjectsUsingBlock:^(id<MBGeneralListDisplaying> dc, NSUInteger idx, BOOL *stop) {
        UIScrollView *sv = [dc listView];
        sv.scrollsToTop = NO;

        if (idx == index) {
            sv.scrollsToTop = YES;
            if (![dc respondsToSelector:@selector(dataSource)]) return;

            MBListDataSource *ds = [(MBTableListDisplayer *)dc dataSource];
            if (![ds respondsToSelector:@selector(hasSuccessFetched)]) return;
            if (!ds.hasSuccessFetched) {
                [dc refresh];
            }
        }
    }];
    UIViewController *selectedVC = self.selectedViewController;
    AppNavigationController().pageName = selectedVC.pageName;
    self.pageAPIGroupIdentifier = selectedVC.APIGroupIdentifier;
}

#pragma mark - MBGeneralListDisplaying

- (UITableView *)listView {
    if ([self.selectedViewController respondsToSelector:@selector(listView)]) {
        return [(id<MBGeneralListDisplaying>)self.selectedViewController listView];
    }
    return nil;
}

- (void)refresh {
    if ([self.selectedViewController respondsToSelector:@selector(refresh)]) {
        [(id<MBGeneralListDisplaying>)self.selectedViewController refresh];
    }
}

@end
