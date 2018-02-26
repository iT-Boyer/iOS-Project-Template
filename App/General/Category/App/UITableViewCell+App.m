
#import "UITableViewCell+App.h"

@implementation UITableViewCell (App)

+ (NSString *)preferReuseIdentifier {
    return NSStringFromClass([self class]);
}

@end
