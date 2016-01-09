
#import "MBCollectionViewCell.h"

@implementation MBCollectionViewCell
RFInitializingRootForUIView

- (void)onInit {

}

- (void)afterInit {
    // Nothing
}

- (void)awakeFromNib {
    [super awakeFromNib];
    self.contentView.autoresizingMask = UIViewAutoresizingFlexibleSize;
}

- (void)onCellSelected {
}

@end
