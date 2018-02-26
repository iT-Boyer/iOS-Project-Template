
#import "UIPickerView+App.h"

@implementation UIPickerView (App)

- (void)rf_selectRow:(NSInteger)row inComponent:(NSInteger)component animated:(BOOL)animated MB_SHOULD_MERGE_INTO_LIB {
    if (component < 0 || component >= self.numberOfComponents) return;
    if (row <0 || row >= [self numberOfRowsInComponent:component]) return;
    [self selectRow:row inComponent:component animated:animated];
}

@end
