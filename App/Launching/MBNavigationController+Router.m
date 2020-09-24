
#import "MBNavigationController+Router.h"
#import "Common.h"
#import <MBAppKit/MBEnvironment.h>

NSString *const AppScheme = @"example";

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
    if (![url.scheme isEqualToString:AppScheme]) return;
    
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
    // FIXME(BB9z): 与 EnvironmentFlag.swift 关联
    MBENVFlag naigationLoaded = 1 << 10;
    if (!url.length) return;
    if ([AppEnv() meetFlags:naigationLoaded]) {
        [AppNavigationController() jumpWithURL:url object:additonalObject];
        return;
    }
    BOOL hasWaiting = _tmp_url.length;
    _tmp_url = url;
    _tmp_obj = additonalObject;
    if (hasWaiting) return;
    [AppEnv() waitFlags:naigationLoaded do:^{
        [AppNavigationController() jumpWithURL:_tmp_url object:_tmp_obj];
        _tmp_url = nil;
        _tmp_obj = nil;
    } timeout:0];
}
