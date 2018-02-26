
#import "MBFormSelectButton.h"
#import "UIKit+App.h"

@interface MBFormSelectButton ()
@end

@implementation MBFormSelectButton

- (void)setHighlighted:(BOOL)highlighted {
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

- (void)setPlaceHolder:(NSString *)placeHolder {
    _placeHolder = placeHolder;
    if (!self.selected) {
        [self setTitle:placeHolder forState:UIControlStateNormal];
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
    if (self.valueDisplayString) {
        return self.valueDisplayString(value);
    }
    return [NSString stringWithFormat:@"%@", value];
}

@end
