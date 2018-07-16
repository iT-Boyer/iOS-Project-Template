
#import "ZYPasswordTextField.h"
#import <RFKit/UIView+RFKit.h>

@interface ZYPasswordTextField ()
@end

@implementation ZYPasswordTextField

- (void)onInit {
    [super onInit];

    if (!self.rightView) {
        self.rightViewMode = UITextFieldViewModeAlways;
        self.rightView = self.triggerPasswordDisplayButton;
    }

    self.secureTextEntry = YES;
    self.triggerPasswordDisplayButton.selected = NO;
}

- (UIButton *)triggerPasswordDisplayButton {
    if (!_triggerPasswordDisplayButton) {
        UIButton *bt = [UIButton buttonWithType:UIButtonTypeCustom];
        [bt setImage:[UIImage imageNamed:@"input_pass_off"] forState:UIControlStateNormal];
        [bt setImage:[UIImage imageNamed:@"input_pass_on"] forState:UIControlStateSelected];
        [bt addTarget:self action:@selector(onPasswordDisplayButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
        [bt setContentEdgeInsets:UIEdgeInsetsMakeWithSameMargin(5)];
        [bt sizeToFit];
        _triggerPasswordDisplayButton = bt;
    }
    return _triggerPasswordDisplayButton;
}

- (IBAction)onPasswordDisplayButtonTapped:(id)sender {
    self.triggerPasswordDisplayButton.selected = !self.triggerPasswordDisplayButton.selected;
    self.secureTextEntry = !self.triggerPasswordDisplayButton.selected;


    // 修正模式切换改变后，光标的位置
    if ([self isFirstResponder]) {
        NSString *text = self.text;
        UITextRange *orgRange = self.selectedTextRange;
        [self resignFirstResponder];
        [self becomeFirstResponder];
        self.text = text;
        self.selectedTextRange = orgRange;
    }
}

@end
