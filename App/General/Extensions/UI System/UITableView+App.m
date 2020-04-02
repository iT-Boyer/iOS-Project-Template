
#import "UITableView+App.h"

@implementation UITableView (App)

- (void)appendAtRang:(NSRange)rang inSection:(NSUInteger)section animated:(BOOL)animated {
    NSMutableArray *indexPaths = [NSMutableArray arrayWithCapacity:rang.length];
    for (NSInteger i = rang.length - 1; i >=0 ; i--) {
        [indexPaths addObject:[NSIndexPath indexPathForRow:i inSection:section]];
    }

    [self insertRowsAtIndexPaths:indexPaths withRowAnimation:animated? UITableViewRowAnimationAutomatic : UITableViewRowAnimationNone];
}

- (NSArray<NSIndexPath *> *)indexPathsForVisibleCells {
    NSMutableArray<NSIndexPath *> *indexPathsForVisibleCells = [NSMutableArray array];
    for (UITableViewCell *visibleCell in self.visibleCells) {
        NSIndexPath *indexPathsForVisibleCell = [self indexPathForCell:visibleCell];
        if (indexPathsForVisibleCell) {
            [indexPathsForVisibleCells addObject:indexPathsForVisibleCell];
        }
    }
    if (indexPathsForVisibleCells.count) {
        return [indexPathsForVisibleCells copy];
    }
    else {
        return nil;
    }
}

@end
