
#import "UICollectionView+App.h"
#import <MBAppKit/NSObject+MBAppKit.h>

@implementation UICollectionView (App)

- (void)registerNibWithClass:(Class)aClass {
    NSString *name = aClass.className;
    UINib *nib = [UINib nibWithNibName:name bundle:nil];
    RFAssert(nib, @"找不到 %@ 对应的 cell nib", aClass);
    [self registerNib:nib forCellWithReuseIdentifier:name];
}

//! REF: http://stackoverflow.com/questions/19032869/ http://stackoverflow.com/questions/19448488/
- (void)safeReloadAnimated:(BOOL)animated {
    if (self.numberOfSections > 0) return;

    [UIView setAnimationsEnabled:animated];
    [self performBatchUpdates:^{
        [self reloadSections:[NSIndexSet indexSetWithIndex:0]];
    } completion:^(BOOL finished) {
        [UIView setAnimationsEnabled:YES];
    }];
}

- (void)deselectItemsAnimated:(BOOL)animated {
    NSArray *items = [self indexPathsForSelectedItems];
    if (!items.count) return;

    [self performBatchUpdates:^{
        // 重新获取选中单元，在这个间隔内状态可能已经变了
        for (NSIndexPath *ip in [self indexPathsForSelectedItems]) {
            [self deselectItemAtIndexPath:ip animated:animated];
        }
    } completion:nil];
}

@end
