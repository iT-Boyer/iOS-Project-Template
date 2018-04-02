
#import "ZYVerifyTextField.h"

@interface ZYVerifyTextField ()
@property (readwrite, copy, nonatomic) NSString *lastCheckString;
@end

@implementation ZYVerifyTextField

- (void)onInit {
    [super onInit];

    if (!self.rightView) {
        self.rightViewMode = UITextFieldViewModeAlways;
        self.rightView = self.indicatorButton;
    }

    [self addTarget:self action:@selector(onEdtingDidBegin) forControlEvents:UIControlEventEditingDidBegin];
    [self addTarget:self action:@selector(onEditingChanged) forControlEvents:UIControlEventEditingChanged];
}

- (void)afterInit {
    [super afterInit];

    self.indicatorButton.activityIndicatorView.activityIndicatorViewStyle = UIActivityIndicatorViewStyleGray;
}

- (void)onEdtingDidBegin {
    [self.operation cancel];
    self.operation = nil;
}

- (void)onEditingChanged {
    self.verifyFaildNoticeView.hidden = YES;
    self.lastCheckString = nil;
}

- (RFRefreshButton *)indicatorButton {
    if (!_indicatorButton) {
        _indicatorButton = [[RFRefreshButton alloc] initWithFrame:CGRectMake(0, 0, 30, 30)];
        _indicatorButton.userInteractionEnabled = NO;
    }
    return _indicatorButton;
}

- (void)setStatus:(ZYVerifyTextFieldStatus)status {
    _status = status;

    RFRefreshButton *bt = self.indicatorButton;

    bt.enabled = (status != ZYVerifyTextFieldStatusChecking);
    bt.hidden = (status == ZYVerifyTextFieldStatusNone);

    if (status == ZYVerifyTextFieldStatusSuccess) {
        bt.iconImageView.image = [UIImage imageNamed:@"input_vaild"];
    }
    else if (status == ZYVerifyTextFieldStatusFail) {
        bt.iconImageView.image = [UIImage imageNamed:@"input_invaild"];
        self.verifyFaildNoticeView.hidden = NO;
    }
}

- (void)setOperation:(NSOperation *)operation {
    if (_operation != operation) {
        [_operation cancel];

        if (!(operation.isCancelled || operation.isFinished)) {
            self.lastCheckString = self.text;
            self.status = ZYVerifyTextFieldStatusChecking;
        }
        else {
            self.status = ZYVerifyTextFieldStatusNone;
        }
        _operation = operation;
    }
}

- (CGRect)textRectForBounds:(CGRect)bounds {
    CGRect frame = [super textRectForBounds:bounds];
    frame.size.width -= 20;
    return frame;
}

@end