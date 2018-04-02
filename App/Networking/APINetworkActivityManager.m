
#import "APINetworkActivityManager.h"
#import "RFKit.h"

@implementation APINetworkActivityManager

#pragma mark - 便捷方法

- (void)showActivityIndicatorWithIdentifier:(NSString *)identifier groupIdentifier:(NSString *)group model:(BOOL)model message:(NSString *)message {
    [self showMessage:[RFNetworkActivityIndicatorMessage messageWithConfiguration:^(RFNetworkActivityIndicatorMessage *instance) {
        instance.identifier = identifier;
        instance.groupIdentifier = group;
        instance.title = nil;
        instance.message = message;
        instance.modal = model;
        instance.status = RFNetworkActivityIndicatorStatusLoading;
    } error:nil]];
}

- (void)showSuccessStatus:(NSString *)message {
    [self showMessage:[RFNetworkActivityIndicatorMessage messageWithConfiguration:^(RFNetworkActivityIndicatorMessage *instance) {
        instance.identifier = @"";
        instance.message = message;
        instance.status = RFNetworkActivityIndicatorStatusSuccess;
        instance.priority = RFMessageDisplayPriorityHigh;
    } error:nil]];
}

- (void)showErrorStatus:(NSString *)message {
    [self showMessage:[RFNetworkActivityIndicatorMessage messageWithConfiguration:^(RFNetworkActivityIndicatorMessage *instance) {
        instance.identifier = @"";
        instance.message = message;
        instance.status = RFNetworkActivityIndicatorStatusFail;
        instance.priority = RFMessageDisplayPriorityHigh;
    } error:nil]];
}

- (void)alertError:(NSError *)error title:(NSString *)title {
    NSMutableArray *ep = [NSMutableArray arrayWithCapacity:3];
    [ep rf_addObject:error.localizedDescription];
    [ep rf_addObject:error.localizedFailureReason];
    [ep rf_addObject:error.localizedRecoverySuggestion];
    NSString *message = [ep componentsJoinedByString:@"\n"];
#if RFDEBUG
    dout_error(@"Error: %@ (%d), URL:%@", error.domain, (int)error.code, error.userInfo[NSURLErrorFailingURLErrorKey]);
#endif
    [self showMessage:[RFNetworkActivityIndicatorMessage messageWithConfiguration:^(RFNetworkActivityIndicatorMessage *instance) {
        instance.identifier = @"";
        instance.message = message;
        instance.status = RFNetworkActivityIndicatorStatusFail;
        instance.priority = RFMessageDisplayPriorityHigh;
    } error:nil]];
}

@end
