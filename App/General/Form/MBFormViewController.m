
#import "MBFormViewController.h"

@interface MBFormViewController ()
@end

@implementation MBFormViewController

- (BOOL)checkFields {
    return YES;
}

- (IBAction)onSubmit:(id)sender {
    if (![self checkFields]) {
        return;
    }
    [self dismissKeyboard];
}

@end
