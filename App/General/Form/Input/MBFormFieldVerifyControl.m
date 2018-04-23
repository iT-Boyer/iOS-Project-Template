
#import "MBFormFieldVerifyControl.h"
#import "MBTextField.h"

@interface MBFormFieldVerifyControl ()
@property (nonatomic) BOOL MBFormFieldVerifyControl_lastVaild;
@end

@implementation MBFormFieldVerifyControl

- (void)setTextFields:(NSArray *)textFields {
    for (UITextField *f in textFields) {
        [f removeTarget:self action:@selector(MBFormFieldVerifyControl_textEdit:) forControlEvents:UIControlEventEditingChanged];
    }
    _textFields = textFields;
    for (UITextField *f in textFields) {
        [f addTarget:self action:@selector(MBFormFieldVerifyControl_textEdit:) forControlEvents:UIControlEventEditingChanged];
    }
    [self MBFormFieldVerifyControl_updateVaild];
}

- (void)setSubmitButton:(id)submitButton {
    _submitButton = submitButton;
    [(UIControl *)self.submitButton setEnabled:self.MBFormFieldVerifyControl_lastVaild];
}

- (void)MBFormFieldVerifyControl_textEdit:(UITextField *)sender {
    [self MBFormFieldVerifyControl_updateVaild];
}

- (void)MBFormFieldVerifyControl_updateVaild {
    BOOL v = YES;
    for (MBTextField *f in self.textFields) {
        if (!f.isFieldVaild) {
            v = NO;
            break;
        }
    }
    self.MBFormFieldVerifyControl_lastVaild = v;
}

- (void)setMBFormFieldVerifyControl_lastVaild:(BOOL)v {
    if (_MBFormFieldVerifyControl_lastVaild == v) return;
    _MBFormFieldVerifyControl_lastVaild = v;
    [(UIControl *)self.submitButton setEnabled:v];
}

@end
