
#import "MBFormTextField.h"
#import "UITextFiledDelegateChain.h"

@interface MBFormTextField ()
@property (strong, nonatomic) UITextFiledDelegateChain *trueDelegate;
@end

@implementation MBFormTextField

- (void)afterInit {
    [super afterInit];

    [self.trueDelegate setDidEndEditing:^(UITextField *aTextField, id<UITextFieldDelegate> delegate) {
        MBFormTextField *textField = (id)aTextField;
        id item = [(id<MBGeneralItemExchanging>)aTextField.viewController item];
        if (textField.name) {
            [item setValue:textField.text forKey:textField.name];
        }

        if ([delegate respondsToSelector:@selector(textFieldDidEndEditing:)]) {
            [delegate textFieldDidEndEditing:aTextField];
        }
    }];
}

@end
