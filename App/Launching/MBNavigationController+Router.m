
#import "MBNavigationController+Router.h"
#import "Common.h"

@implementation MBNavigationController (Router)

#define _CommandJump(STRING, VCCLASS, MODEL) \
    else if ([command isEqualToString:@STRING]) {\
        vc = (id)[VCCLASS newFromStoryboard];\
        MODEL *item = [MODEL new];\
        item.uid = itemID;\
        if ([item respondsToSelector:@selector(setIncompletion:)]) {\
            [(id<MBModelCompleteness>)item setIncompletion:@(YES)];\
        }\
        if ([item respondsToSelector:@selector(completeEntityFromCache)]) {\
            item = [(id<MBModelCompleteness>)item completeEntityFromCache];\
        }\
        vc.item = item;\
    }

#define _CommandJumpVC(STRING, VCCLASS) \
    else if ([command isEqualToString:@STRING]) {\
        vc = (id)[VCCLASS newFromStoryboard];\
    }

- (void)jumpWithURL:(nullable NSString *)urlString object:(nullable id)object {
    NSURL *url = [NSURL URLWithString:urlString];
    if (url.isHTTPURL) {
        [UIApplication.sharedApplication openURL:url];
        return;
    }
    if (![url.scheme isEqualToString:@"com.znart"]) return;
    
    // 相同页面不再跳转
    if ([url isEqual:self.currentPageURL]) {
        return;
    }
    
    NSString *command = url.host;
    // 无命令则不是一个有效命令，忽略
    if (!command) return;
    
    NSDictionary *query = url.queryDictionary;
    NSArray *pathComponents = url.pathComponents;
    NSString *itemIDString = [pathComponents rf_objectAtIndex:1];
    MBID itemID = [itemIDString longLongValue];
    
#pragma mark -
    UIViewController<MBGeneralItemExchanging> *vc;
    
    if (0) { } // for else below
//    _CommandJump("user", UserDetailViewController, UserEntity)

    if (vc) {
        [self pushViewController:vc animated:YES];
    }
}

- (NSURL *)currentPageURL {
    UIViewController *vc = self.visibleViewController;
    return [vc respondsToSelector:@selector(pageURL)]? vc.pageURL : nil;
}

@end

static NSString *_tmp_url = nil;
static id _tmp_obj = nil;

void AppNavigationJump(NSString *__nullable url, id __nullable additonalObject) {
    if (!url.length) return;
    if ([AppEnv() meetFlags:MBENVFlagNaigationLoaded]) {
        [AppNavigationController() jumpWithURL:url object:additonalObject];
        return;
    }
    _tmp_url = url;
    _tmp_obj = additonalObject;
    [AppEnv() waitFlags:MBENVFlagNaigationLoaded do:^{
        [AppNavigationController() jumpWithURL:_tmp_url object:_tmp_obj];
        _tmp_url = nil;
        _tmp_obj = nil;
    } timeout:0];
}
