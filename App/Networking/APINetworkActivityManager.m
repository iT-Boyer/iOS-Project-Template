
#import "APINetworkActivityManager.h"
#import "SVProgressHUD.h"

@interface APINetworkActivityManager ()
@property (strong, nonatomic) id dismissObserver;
@end

@implementation APINetworkActivityManager

- (void)afterInit {
    [super afterInit];
    [SVProgressHUD setMinimumDismissTimeInterval:1];
}

- (void)dealloc {
    [self deactiveAutoDismissObserver];
}

- (void)replaceMessage:(RFNetworkActivityIndicatorMessage *)displayingMessage withNewMessage:(RFNetworkActivityIndicatorMessage *)message {
    _dout_info(@"Replace message %@ with %@", displayingMessage, message)
    [super replaceMessage:displayingMessage withNewMessage:message];

    if (!message) {
        [SVProgressHUD dismiss];
        return;
    }

    NSString *stautsString = (message.title.length && message.message.length)? [NSString stringWithFormat:@"%@: %@", message.title, message.message] : [NSString stringWithFormat:@"%@%@", message.title?: @"", message.message?: @""];

    SVProgressHUDMaskType maskType = message.modal? SVProgressHUDMaskTypeBlack : SVProgressHUDMaskTypeNone;
    [SVProgressHUD setDefaultMaskType:maskType];
    switch (message.status) {
        case RFNetworkActivityIndicatorStatusSuccess: {
            [self activeAutoDismissObserver];
            [SVProgressHUD showSuccessWithStatus:stautsString];
            break;
        }

        case RFNetworkActivityIndicatorStatusFail: {
            [self activeAutoDismissObserver];
            [SVProgressHUD showErrorWithStatus:stautsString];
            break;
        }
        case RFNetworkActivityIndicatorStatusDownloading:
        case RFNetworkActivityIndicatorStatusUploading: {
            [self deactiveAutoDismissObserver];
            [SVProgressHUD showProgress:message.progress status:stautsString];
        }
        default: {
            if (stautsString.length) {
                [SVProgressHUD showWithStatus:stautsString];
            }
            else {
                [SVProgressHUD show];
            }
        }
    }

    _dout_info(@"After replacing, self = %@", self);
}

- (void)activeAutoDismissObserver {
    if (self.dismissObserver) return;

    @weakify(self);
    self.dismissObserver = [[NSNotificationCenter defaultCenter] addObserverForName:SVProgressHUDWillDisappearNotification object:nil queue:nil usingBlock:^(NSNotification *note) {
        @strongify(self);
        _dout_info(@"Receive SVProgressHUDWillDisappearNotification")
        if (self.displayingMessage) {
            RFAssert(self.displayingMessage.identifier, @"empty string");
            [self hideWithIdentifier:self.displayingMessage.identifier];
        }
    }];
}

- (void)deactiveAutoDismissObserver {
    if (self.dismissObserver) {
        [[NSNotificationCenter defaultCenter] removeObserver:self.dismissObserver];
        self.dismissObserver = nil;
    }
}

@end
