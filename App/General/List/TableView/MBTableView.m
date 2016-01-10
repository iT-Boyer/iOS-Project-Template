
#import "MBTableView.h"
#import "API.h"
#import "MBRefreshFooterView.h"

@interface MBTableView ()
@property (weak, nonatomic) id<MBTableViewDelegate> delegate;
@property (strong, nonatomic) MBTableViewDataSource *trueDataSource;
@end

@implementation MBTableView
@dynamic delegate;
RFInitializingRootForUIView

- (void)onInit {
    self.trueDataSource = [MBTableViewDataSource new];
    self.trueDataSource.tableView = self;
    [super setDataSource:self.trueDataSource];
    self.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
}

- (void)afterInit {
    [self cellHeightManager];
    [self pullToFetchController];
}

- (void)dealloc {
    [super setDataSource:nil];
    [super setDelegate:nil];
}

- (RFTableViewCellHeightDelegate *)cellHeightManager {
    if (!_cellHeightManager) {
        _cellHeightManager = [[RFTableViewCellHeightDelegate alloc] init];
        _cellHeightManager.delegate = (id)self.delegate;
        self.delegate = (id)_cellHeightManager;
    }
    return _cellHeightManager;
}

- (MBTableViewPullToFetchControl *)pullToFetchController {
    if (!_pullToFetchController) {
        _pullToFetchController = ({
            MBTableViewPullToFetchControl *control = [[MBTableViewPullToFetchControl alloc] init];
            control.shouldScrollToTopWhenHeaderEventTrigged = YES;
            control.tableView = self;

            @weakify(self);
            [control setHeaderProcessBlock:^{
                @strongify(self);
                [self fetchItemsWithPageFlag:NO];
            }];

            [control setFooterProcessBlock:^{
                @strongify(self);
                [self fetchItemsWithPageFlag:(self.dataSource.page != 0)];
            }];
            
            control;
        });
    }
    return _pullToFetchController;
}

- (void)fetchItemsWithPageFlag:(BOOL)nextPage {
    __block BOOL success = NO;
    @weakify(self);
    [self.dataSource fetchItemsFromViewController:self.viewController nextPage:nextPage success:^(MBListDataSource *dateSource, NSArray *fetchedItems) {
        @strongify(self);
        if (!nextPage) {
            [self.cellHeightManager invalidateCellHeightCache];
            MBRefreshFooterView *fv = (id)self.pullToFetchController.footerContainer;
            fv.empty = dateSource.empty;
            MBRefreshHeaderView *hv = (id)self.pullToFetchController.headerContainer;
            hv.empty = dateSource.empty;
        }
        self.pullToFetchController.footerReachEnd = dateSource.pageEnd;
        success = YES;
    } completion:^(MBListDataSource *dateSource) {
        @strongify(self);
        self.pullToFetchController.autoFetchWhenScroll = success;
        [self.pullToFetchController markProcessFinshed];
        if (self.fetchPageEnd) {
            self.fetchPageEnd(nextPage, dateSource);
        }
    }];
}

- (void)reload {
    if (_cellHeightManager) {
        [self.cellHeightManager invalidateCellHeightCache];
    }
    [self reloadData];
}

- (void)reloadData {
    // 按理应该显示出来再 load，不加貌似有时启动时会有奇怪的问题，但又不能复现……
    if (self.window) {
        [super reloadData];
    }
}

- (void)willMoveToWindow:(UIWindow *)newWindow {
    [super willMoveToWindow:newWindow];
    if (newWindow) {
        if (self.autoFetchWhenMoveToWindow
            && !self.dataSource.hasSuccessFetched) {
            [self.pullToFetchController triggerHeaderProcess];
        }
        else {
            [self.pullToFetchController setNeedsDisplayHeader];
        }
    }
}

- (void)removeItem:(id)item withRowAnimation:(UITableViewRowAnimation)animation {
    NSIndexPath *ip = [self.dataSource indexPathForItem:item];
    if (ip) {
        [self.cellHeightManager invalidateCellHeightCache];
        [self.dataSource.items removeObjectAtIndex:ip.row];
        [self deleteRowsAtIndexPaths:@[ ip ] withRowAnimation:animation];
    }
}

- (void)prepareForReuse {
    [self.dataSource prepareForReuse];
    [self.pullToFetchController markProcessFinshed];
    self.pullToFetchController.footerReachEnd = NO;
    [self reload];
}

- (void)insertRowsWithRowRange:(NSRange)range inSection:(NSInteger)section rowAnimation:(UITableViewRowAnimation)animation {
    NSMutableArray *indexPathes = [NSMutableArray arrayWithCapacity:range.length];
    for (NSUInteger i = 0; i < range.length; i++) {
        [indexPathes addObject:[NSIndexPath indexPathForRow:range.location + i inSection:section]];
    }
    [self insertRowsAtIndexPaths:indexPathes withRowAnimation:animation];
}

- (void)deleteRowsWithRowRange:(NSRange)range inSection:(NSInteger)section rowAnimation:(UITableViewRowAnimation)animation {
    NSMutableArray *indexPathes = [NSMutableArray arrayWithCapacity:range.length];
    for (NSUInteger i = 0; i < range.length; i++) {
        [indexPathes addObject:[NSIndexPath indexPathForRow:range.location + i inSection:section]];
    }
    [self deleteRowsAtIndexPaths:indexPathes withRowAnimation:animation];
}

#pragma mark - DataSource Forward

- (void)setDataSource:(id<UITableViewDataSource>)dataSource {
    self.trueDataSource.delegate = dataSource;
}

- (id<UITableViewDataSource>)dataSource {
    return self.trueDataSource;
}

#pragma mark - Cell height
#pragma mark Update

- (void)updateCellHeightAtIndexPath:(NSIndexPath *)indexPath animated:(BOOL)animated {
    if (indexPath) {
        [self.cellHeightManager invalidateCellHeightCacheAtIndexPath:indexPath];
        [self reloadRowsAtIndexPaths:@[ indexPath ] withRowAnimation:animated? UITableViewRowAnimationFade : UITableViewRowAnimationNone];
    }
}

- (void)updateCellHeightOfCell:(UITableViewCell *)cell animated:(BOOL)animated {
    NSIndexPath *ip = [self indexPathForCell:cell];
    if (ip) {
        [self updateCellHeightAtIndexPath:ip animated:YES];
    }
}

@end