
#import "NSOperationQueue+App.h"

@implementation NSOperationQueue (App)

- (void)performSynchronouslyWithBlock:(void (^_Nonnull)(void))block {
    NSParameterAssert(block);
    if ([NSOperationQueue currentQueue] == self) {
        block();
    }
    else {
        NSOperation *op = [NSBlockOperation blockOperationWithBlock:block];
        [self addOperations:@[ op ] waitUntilFinished:YES];
    }
}

@end
