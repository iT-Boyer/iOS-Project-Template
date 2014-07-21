
#import "MBFormSelectButton.h"
#import "UIKit+App.h"

@interface MBFormSelectButton ()
@end

@implementation MBFormSelectButton
RFInitializingRootForUIView

+ (void)load {
    [[self appearance] setBackgroundImage:[UIImage imageNamed:@"select_button_bg"] forState:UIControlStateNormal];
}

- (void)onInit {
    [self setTitleColor:[UIColor globalPlaceholderTextColor] forState:UIControlStateNormal];
    [self setTitleColor:[UIColor globalTextColor] forState:UIControlStateSelected];
    self.titleEdgeInsets = UIEdgeInsetsMake(0, 10, 0, 25);
}

- (void)afterInit {
}

- (CGSize)intrinsicContentSize {
    CGSize size = [super intrinsicContentSize];
    size.height = MAX(size.height, 36);
    return size;
}

- (void)awakeFromNib {
    [super awakeFromNib];

    if (!self.placeHolder) {
        self.placeHolder = [self titleForState:UIControlStateNormal];
    }
}

- (void)setSelectedVaule:(id)selectedVaule {
    if (_selectedVaule != selectedVaule) {
        [self setTitle:[self displayStringWithValue:selectedVaule] forState:UIControlStateSelected];
        self.selected = !!(selectedVaule);
        _selectedVaule = selectedVaule;
    }
}

- (NSString *)displayStringWithValue:(id)value {
    return [NSString stringWithFormat:@"%@", value];
}

@end
