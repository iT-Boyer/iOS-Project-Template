
#import "MBTableView.h"
#import "API.h"
#import "MBRefreshFooterView.h"

@interface MBTableView ()
@property (weak, nonatomic) id<MBTableViewDelegate> delegate;
@property (strong, nonatomic) MBTableViewDataSource *trueDataSource;
@end

@implementation MBTableView
RFInitializingRootForUIView

- (void)onInit {
    self.trueDataSource = [MBTableViewDataSource new];
    self.trueDataSource.tableView = self;
    [super setDataSource:self.trueDataSource];
}

- (void)afterInit {
    [self cellHeightManager];
    [self pullToFetchController];
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
        MBTableViewPullToFetchControl *control = [[MBTableViewPullToFetchControl alloc] init];
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

        _pullToFetchController = control;
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
        }
        self.pullToFetchController.footerReachEnd = dateSource.pageEnd;
        success = YES;
    } completion:^(MBListDataSource *dateSource) {
        @strongify(self);
        self.pullToFetchController.autoFetchWhenScroll = success;
        [self.pullToFetchController markProcessFinshed];
    }];
}

- (void)reload {
    if (_cellHeightManager) {
        [self.cellHeightManager invalidateCellHeightCache];
    }
    [self reloadData];
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
