
#import "MBAutoSearchBar.h"
#import "UISearchBarDelegateChain.h"
#import "RFTimer.h"

@interface MBAutoSearchBar ()
@property (readwrite, strong, nonatomic) UISearchBarDelegateChain *trueDelegate;
@property (strong, nonatomic) RFTimer *autoSearchTimer;
@end

@implementation MBAutoSearchBar
RFInitializingRootForUIView

- (void)onInit {
    self.autoSearchTimeInterval = 0.6;
    [super setDelegate:self.trueDelegate];

    @weakify(self);
    [self.trueDelegate setDidChange:^(UISearchBar *searchBar, NSString *searchText, id<UISearchBarDelegate> delegate) {
        @strongify(self);
        self.autoSearchTimer.suspended = YES;
        self.autoSearchTimer.suspended = NO;

        if ([delegate respondsToSelector:@selector(searchBar:textDidChange:)]) {
            [delegate searchBar:searchBar textDidChange:searchText];
        }
    }];

    [self.trueDelegate setSearchButtonClicked:^(UISearchBar *searchBar, id<UISearchBarDelegate> delegate) {
        @strongify(self);
        NSString *keyword = [self.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
        [self doSearchWithKeyword:keyword force:YES];

        if ([delegate respondsToSelector:@selector(searchBarSearchButtonClicked:)]) {
            [delegate searchBarSearchButtonClicked:searchBar];
        }
    }];
}

- (void)afterInit {
}

- (void)setAutoSearchTimeInterval:(float)autoSearchTimeInterval {
    _autoSearchTimeInterval = autoSearchTimeInterval;
    if (autoSearchTimeInterval <= 0) {
        [self.autoSearchTimer invalidate];
    }
    else {
        self.autoSearchTimer.timeInterval = autoSearchTimeInterval;
    }
}

- (RFTimer *)autoSearchTimer {
    if (!_autoSearchTimer && self.autoSearchTimeInterval > 0) {
        _autoSearchTimer = [RFTimer new];
        _autoSearchTimer.timeInterval = self.autoSearchTimeInterval;

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

    NSString *keyword = [self.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    _douto(keyword)

    if (![keyword isEqualToString:self.searchingKeyword]) {
        [self doSearchWithKeyword:keyword force:NO];
    }
}

- (void)doSearchWithKeyword:(NSString *)keyword force:(BOOL)force {
    _douto(keyword)
    _douto(self.searchingKeyword)
    if (self.disallowEmptySearch && !keyword.length) {
        return;
    }

    if (force || ![keyword isEqualToString:self.searchingKeyword]) {
        self.searchOperation = nil;
        self.searchingKeyword = keyword;

        if (self.doSearch) {
            self.doSearch(self, self.searchingKeyword);
        }
    }
}

- (void)setSearchOperation:(NSOperation *)searchOperation {
    if (_searchOperation) {
        [_searchOperation cancel];
    }

    _searchOperation = searchOperation;
}

#pragma mark - Delegate

- (void)setDelegate:(id<UISearchBarDelegate>)delegate {
    self.trueDelegate.delegate = delegate;
}

- (UISearchBarDelegateChain *)trueDelegate {
    if (!_trueDelegate) {
        _trueDelegate = [UISearchBarDelegateChain new];
    }
    return _trueDelegate;
}

@end
