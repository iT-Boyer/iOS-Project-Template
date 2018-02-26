
#import "MBCollectionView.h"
#import "RFKVOWrapper.h"

@interface MBCollectionView ()
@property (nonatomic) BOOL refreshFooterViewStatusUpdateFlag;

/// 真实的 contentInset 被劫持了，这个属性存储的是外部设置的 contentInset，实际 contentInset 会加上 header 高度
@property (nonatomic) UIEdgeInsets trueContentInset;
@property (weak, nonatomic) id footerStatusObserver;
@property (nonatomic) CGFloat lastHeaderViewHeight;
@end

@implementation MBCollectionView
@dynamic dataSource;
RFInitializingRootForUIView

- (NSString *)debugDescription {
    return [NSString stringWithFormat:@"<%@: %p, content>", self.class, self];
}

- (void)onInit {
    self.trueDataSource = [MBCollectionViewDataSource new];
    self.alwaysBounceVertical = YES;

    [self registerNib:[UINib nibWithNibName:@metamacro_stringify(MBCollectionRefreshFooterView) bundle:nil] forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:@metamacro_stringify(MBCollectionRefreshFooterView)];
}

- (void)afterInit {
    __weak UIRefreshControl *rc = _mb_refreshControl;
    @weakify(self);
    [self RFAddObserver:self forKeyPath:@keypath(self, refreshFooterViewStatusUpdateFlag) options:NSKeyValueObservingOptionInitial|NSKeyValueObservingOptionNew queue:nil block:^(id observer, NSDictionary *change) {
        @strongify(self);
        rc.enabled = !self.dataSource.fetching;
        [self updateFooterStatus];
    }];
}

- (UIRefreshControl *)mb_refreshControl {
    if (!_mb_refreshControl) {
        _mb_refreshControl = ({
            UIRefreshControl *rc = [UIRefreshControl new];
            [rc addTarget:self action:@selector(onRefreshControlStatusChanged) forControlEvents:UIControlEventValueChanged];
            [self addSubview:rc];
            rc;
        });
    }
    return _mb_refreshControl;
}

- (void)setHeaderView:(UIView *)headerView {
    _headerView = headerView;
    
    CGSize size = headerView.bounds.size;
    size.width = self.width;
    ((UICollectionViewFlowLayout *)self.collectionViewLayout).headerReferenceSize = size;
}

- (void)dealloc {
    self.delegate = nil;
}

- (void)onRefreshControlStatusChanged {
    UIRefreshControl *rc = _mb_refreshControl;
    if (rc.refreshing) {
        MBCollectionViewDataSource *ds = self.dataSource;
        [ds fetchItemsFromViewController:self.viewController nextPage:NO success:^(MBCollectionViewDataSource *dateSource, NSArray *fetchedItems) {
            [dateSource.collectionView reloadData];
            [rc endRefreshing];
        } completion:nil];
    }
}

+ (NSSet *)keyPathsForValuesAffectingRefreshFooterViewStatusUpdateFlag {
    MBCollectionView *this;
    return [NSSet setWithObjects:@keypath(this, dataSource.fetching), @keypath(this, dataSource.pageEnd), @keypath(this, dataSource.empty), nil];
}

- (void)updateFooterStatus {
    MBCollectionViewDataSource *ds = self.dataSource;
    MBCollectionRefreshFooterView *ft = self.refreshFooterView;
    if (ds.fetching) {
        ft.status = RFRefreshControlStatusFetching;
    }
    else if (ds.empty) {
        ft.status = RFRefreshControlStatusEmpty;
    }
    else if (ds.pageEnd) {
        ft.status = RFRefreshControlStatusEnd;
    }
    else {
        ft.status = RFRefreshControlStatusWaiting;
    }
}

- (MBCollectionRefreshFooterView *)refreshFooterView {
    if (!_refreshFooterView) {
        @try {
            // 等内容加载出来再尝试创建，否则会抛异常
            if (self.collectionViewLayout.collectionViewContentSize.height > 10) {
                _refreshFooterView = [self dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:@metamacro_stringify(MBCollectionRefreshFooterView) forIndexPath:[NSIndexPath indexPathForItem:0 inSection:0]];
            }
        }
        @catch (NSException *exception) {
            douto(exception)
        }
    }
    return _refreshFooterView;
}

- (void)prepareForReuse {
    [self.dataSource prepareForReuse];
    [self reloadData];
}

#pragma mark - Data Source

- (void)setDataSource:(MBCollectionViewDataSource *)dataSource {
    if ([dataSource isKindOfClass:[MBCollectionViewDataSource class]]) {
        self.trueDataSource = dataSource;
    }
    else {
        if (self.trueDataSource) {
            self.trueDataSource.delegate = dataSource;
        }
        else {
            [super setDataSource:dataSource];
        }
    }
}

- (void)setTrueDataSource:(MBCollectionViewDataSource *)trueDataSource {
    _trueDataSource = trueDataSource;
    trueDataSource.collectionView = self;
    if (![self.dataSource isKindOfClass:[MBCollectionViewDataSource class]]) {
        trueDataSource.delegate = self.dataSource;
    }
    [super setDataSource:trueDataSource];
}

#pragma mark - Collection Header View

/**
 利用 contentInset 增加顶部空间，独立于 UICollectionViewLayout 单独布局

 */
- (void)setContentInset:(UIEdgeInsets)contentInset {
    self.trueContentInset = contentInset;

    _dout_insets(contentInset)
    CGFloat headerViewHeight = self.collectionHeaderView.height;
    contentInset.top += headerViewHeight;
    _dout_insets(contentInset)
    [super setContentInset:contentInset];
}

- (UIEdgeInsets)contentInset {
    return self.trueContentInset;
}

- (void)setCollectionHeaderView:(UIView *)collectionHeaderView {
    // Setup frame
    UIEdgeInsets contentInset = self.trueContentInset;
    _dout_insets(contentInset)

    CGRect frame = collectionHeaderView.frame;
    frame.origin.x = 0;
    frame.origin.y = contentInset.top - collectionHeaderView.height;
    frame.size.width = self.width;
    collectionHeaderView.frame = frame;
    _dout_rect(frame)

    // Setup view hierarchy
    if (_collectionHeaderView != collectionHeaderView) {
        if (_collectionHeaderView) {
            [_collectionHeaderView removeFromSuperview];
        }

        if (collectionHeaderView.superview != self) {
            [collectionHeaderView removeFromSuperview];
            collectionHeaderView.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleBottomMargin;
            collectionHeaderView.translatesAutoresizingMaskIntoConstraints = YES;
            [self addSubview:collectionHeaderView];
        }

        // Adjust header offset when header is visable
        if (self.contentOffset.y <= 0) {
            CGPoint offset = self.contentOffset;
            offset.y = -collectionHeaderView.height;
            self.contentOffset = offset;
        }

        _collectionHeaderView = collectionHeaderView;
    }
    else {
        // 同一个 header 的更新效果只是刷新 offset
        CGPoint offsetAdjust = self.contentOffset;
        offsetAdjust.y += self.lastHeaderViewHeight - collectionHeaderView.height;
        self.contentOffset = offsetAdjust;
    }
    self.lastHeaderViewHeight = collectionHeaderView.height;

    __unused CGFloat height = frame.size.height;

    _dout_rect(self.bounds)
    _dout_bool(CGRectContainsRect(frame, self.bounds))
    // 如果 header 在视野内，需要调整 offset 使内容向下移动
    // 不在视野内无操作防抖动
//    if (CGRectContainsRect(frame, self.bounds)) {
//        // 上面留出的空白
//        CGFloat currentTopPadding = [super contentOffset].y - contentInset.top;
//        dout_float(currentTopPadding)
//        dout_float(height)
//
//        CGPoint offset = self.contentOffset;
//        offset.y -= height - currentTopPadding;
//        self.contentOffset = offset;
//    }
//    dout_point(self.contentOffset)

    // 调整 collection view 顶部空白
    // 在最后更新是因为 contentInset 内的设置依赖 header 高度
    self.contentInset = contentInset;
}

@end

@interface MBCollectionViewHeaderFooterView ()
@property (nonatomic) BOOL hasLayoutOnce;
@end

@implementation MBCollectionViewHeaderFooterView
RFInitializingRootForUIView

- (void)onInit {
    self.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleBottomMargin;
    self.translatesAutoresizingMaskIntoConstraints = YES;
}

- (void)afterInit {
}

- (void)updateHeightIfNeeded {
    if (!self.contentView) return;

    CGFloat heightShouldBe = self.contentView.height;
    if (self.height != heightShouldBe) {
        [self updateHeight];
    }
}

- (void)updateHeight {
    if (self.contentView) {
        // ??: 图像高过小 contentView 会不断浮动导致死循环
        self.height = floor(self.contentView.height);
    }
    dout_float(self.contentView.height);

    MBCollectionView *tb = (id)self.superview;
    if ([tb isKindOfClass:[MBCollectionView class]]) {
        tb.collectionHeaderView = self;
    }
}

- (void)updateHeightAnimated:(BOOL)animated {
    [UIView animateWithDuration:.3 delay:0 options:UIViewAnimationOptionCurveEaseInOut animated:animated beforeAnimations:nil animations:^{
        [self updateHeight];
    } completion:nil];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    if (!self.hasLayoutOnce) {
        self.hasLayoutOnce = YES;
        if (!RF_iOS8Before) {
            [self updateHeightIfNeeded];
        }
        [self RFAddObserver:self forKeyPath:@keypath(self, contentView.bounds) options:NSKeyValueObservingOptionNew queue:nil block:^(MBCollectionViewHeaderFooterView *observer, NSDictionary *change) {
            [observer updateHeightIfNeeded];
        }];
    }
}

@end
