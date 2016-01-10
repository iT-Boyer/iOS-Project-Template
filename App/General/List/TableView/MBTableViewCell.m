
#import "MBTableViewCell.h"

@implementation MBTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    if (self.selectedBackgroundEnable) {
        self.selectedBackgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"highlight"]];
    }
}

- (void)setItem:(id)item offscreenRendering:(BOOL)offscreenRendering {
    self.item = item;
}

+ (CGFloat)heightForItem:(id)item width:(CGFloat)width {
    return 44;
}

- (NSIndexPath *)indexPath {
    if (!_indexPath) {
        UITableView *tb = [self superviewOfClass:[UITableView class]];
        _indexPath = [tb indexPathForCell:self];
    }
    return _indexPath;
}

- (void)onCellSelected {
}

+ (NSString *)reuseIdentifierForItem:(id)item {
    return NSStringFromClass(self);
}

@end
