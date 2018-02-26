
#import "ZYSMSCodeSendButton.h"
#import "RFTimer.h"

@interface ZYSMSCodeSendButton ()
@property (strong, nonatomic) RFTimer *timer;
@end

@implementation ZYSMSCodeSendButton

- (void)onInit {
    [super onInit];

    if (_frozeSecond <= 0) {
        _frozeSecond = 60;
    }
}

- (void)awakeFromNib {
    [super awakeFromNib];

    if (!self.disableNoticeFormat) {
        self.disableNoticeFormat = [self titleForState:UIControlStateDisabled];
    }
}

- (void)setEnabled:(BOOL)enabled {
    [super setEnabled:enabled];
    [self invalidateIntrinsicContentSize];
}

- (void)froze {
    self.enabled = NO;
    if (self.timer.isScheduled) return;

    NSString *initTitle = [NSString stringWithFormat:self.disableNoticeFormat, self.frozeSecond];
    [self setTitle:initTitle forState:UIControlStateDisabled];
    self.unfreezeTime = [NSDate timeIntervalSinceReferenceDate] + self.frozeSecond;

    @weakify(self);
    self.timer = [RFTimer scheduledTimerWithTimeInterval:1 repeats:YES fireBlock:^(RFTimer *timer, NSUInteger repeatCount) {
        @strongify(self);
        NSInteger left = self.unfreezeTime - [NSDate timeIntervalSinceReferenceDate];
        if (left <= 0) {
            [self.timer invalidate];
            self.timer = nil;
            self.enabled = YES;
        }
        else {
            [self setTitle:[NSString stringWithFormat:self.disableNoticeFormat, left] forState:UIControlStateDisabled];
        }
    }];
}

@end
