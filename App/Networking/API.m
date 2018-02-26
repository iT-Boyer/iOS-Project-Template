
#import "debug.h"
#import "API.h"
#import "APIConfig.h"
#import "APIJSONResponseSerializer.h"
#import "RFSVProgressMessageManager.h"

#import "AFNetworkActivityLogger.h"
#import "AFNetworkActivityIndicatorManager.h"
#import "NSJSONSerialization+RFKit.h"
#import "NSDateFormatter+RFKit.h"
#import "UIDevice+RFKit.h"
#import "NSFileManager+RFKit.h"
#import "MBRootNavigationController.h"

RFDefineConstString(APIErrorDomain);

@interface API () <
    UIAlertViewDelegate
>

@end

@implementation API

+ (instancetype)sharedInstance {
    static id sharedInstance = nil;
    static dispatch_once_t oncePredicate;
    dispatch_once(&oncePredicate, ^{
        sharedInstance = [[self alloc] init];
    });
    return sharedInstance;
}

- (APIUserPlugin *)user {
    if (!_user) {
        APIUserPlugin *up = [APIUserPlugin new];
        up.shouldRememberPassword = YES;
        up.shouldAutoLogin = YES;
        _user = up;
    }
    return _user;
}

- (void)onInit {
    [super onInit];

    // 接口总体设置
    NSString *configPath = [[NSBundle mainBundle] pathForResource:@"APIDefine" ofType:@"plist"];
    NSDictionary *rules = [[NSDictionary alloc] initWithContentsOfFile:configPath];
    [self.defineManager setDefinesWithRulesInfo:rules];
    self.defineManager.defaultRequestSerializer = [AFJSONRequestSerializer serializer];
    APIJSONResponseSerializer *rps = [APIJSONResponseSerializer serializer];
    self.defineManager.defaultResponseSerializer = rps;    self.maxConcurrentOperationCount = 2;

    // 设置属性
    self.networkActivityIndicatorManager = [RFSVProgressMessageManager new];

    // 配置网络
    if ([UIDevice currentDevice].isBeingDebugged) {
        [[AFNetworkActivityLogger sharedLogger] startLogging];
        [AFNetworkActivityLogger sharedLogger].level = AFLoggerLevelDebug;
    }
    [AFNetworkActivityIndicatorManager sharedManager].enabled = YES;
}

- (void)afterInit {
    [super afterInit];

//    self.appUpdatePlugin.checkSource = APIAppUpdatePluginCheckSourceEnterpriseDistributionPlist;
//    [self.appUpdatePlugin checkUpdateSilence:YES completion:nil];
}

#pragma mark - 请求管理

+ (AFHTTPRequestOperation *)requestWithName:(NSString *)APIName parameters:(NSDictionary *)parameters viewController:(UIViewController *)viewController loadingMessage:(NSString *)message modal:(BOOL)modal success:(void (^)(AFHTTPRequestOperation *, id))success completion:(void (^)(AFHTTPRequestOperation *))completion {
    return [self requestWithName:APIName parameters:parameters viewController:viewController forceLoad:NO loadingMessage:message modal:modal success:success failure:nil completion:completion];
}

+ (AFHTTPRequestOperation *)requestWithName:(NSString *)APIName parameters:(NSDictionary *)parameters viewController:(UIViewController *)viewController forceLoad:(BOOL)forceLoad loadingMessage:(NSString *)message modal:(BOOL)modal success:(void (^)(AFHTTPRequestOperation *, id))success failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure completion:(void (^)(AFHTTPRequestOperation *))completion {
    RFAPIControl *cn = [[RFAPIControl alloc] init];
    if (message) {
        cn.message = [[RFNetworkActivityIndicatorMessage alloc] initWithIdentifier:APIName title:nil message:message status:RFNetworkActivityIndicatorStatusLoading];
        cn.message.modal = modal;
    }
    cn.identifier = APIName;
    cn.groupIdentifier = NSStringFromClass(viewController.class);
    cn.forceLoad = forceLoad;
    return [[self sharedInstance] requestWithName:APIName parameters:parameters controlInfo:cn success:success failure:failure completion:completion];
}

+ (void)cancelOperationsWithViewController:(id)viewController {
    [[API sharedInstance] cancelOperationsWithGroupIdentifier:NSStringFromClass([viewController class])];
}

#pragma mark - 状态提醒

+ (void)showSuccessStatus:(NSString *)message {
    [[API sharedInstance].networkActivityIndicatorManager showWithTitle:nil message:message status:RFNetworkActivityIndicatorStatusSuccess modal:NO priority:RFNetworkActivityIndicatorMessagePriorityHigh autoHideAfterTimeInterval:0 identifier:nil groupIdentifier:nil userInfo:nil];
}

+ (void)showErrorStatus:(NSString *)message {
    [[API sharedInstance].networkActivityIndicatorManager showWithTitle:nil message:message status:RFNetworkActivityIndicatorStatusFail modal:NO priority:RFNetworkActivityIndicatorMessagePriorityHigh autoHideAfterTimeInterval:0 identifier:nil groupIdentifier:nil userInfo:nil];
}

+ (void)alertError:(NSError *)error title:(NSString *)title {
    [[API sharedInstance].networkActivityIndicatorManager alertError:error title:title];
}


#pragma mark - 通用流程

- (BOOL)generalHandlerForError:(NSError *)error withDefine:(RFAPIDefine *)define controlInfo:(RFAPIControl *)controlInfo requestOperation:(AFHTTPRequestOperation *)operation operationFailureCallback:(void (^)(AFHTTPRequestOperation *, NSError *))operationFailureCallback {
    if ([error.domain isEqualToString:APIErrorDomain] && error.code == 403) {
        [self.networkActivityIndicatorManager alertError:error title:@"请重新登录"];
        dispatch_after_seconds(1, ^{
            [self.user logout];
        });
        return NO;
    }
    return YES;
}

- (BOOL)isSuccessResponse:(__autoreleasing id *)responseObjectRef error:(NSError *__autoreleasing *)error {
    // TODO: 判断是否是成功响应
    return YES;
}

#pragma mark - 具体业务


#pragma mark - App update

- (APIAppUpdatePlugin *)appUpdatePlugin {
    if (!_appUpdatePlugin) {
        APIAppUpdatePlugin *up = [[APIAppUpdatePlugin alloc] initWithMaster:self];
        up.enterpriseDistributionPlistURL = [NSURL URLWithString: APIConfigEnterpriseDistributionURL];
        _appUpdatePlugin = up;
    }
    return _appUpdatePlugin;
}

@end

#import "UIImageView+WebCache.h"

@implementation UIImageView (App)

- (void)setImageWithURLString:(NSString *)path placeholderImage:(UIImage *)placeholder {
    [self setImageWithURLString:path placeholderImage:placeholder completion:nil];
}

- (void)setImageWithURLString:(NSString *)path placeholderImage:(UIImage *)placeholderImage completion:(void (^)(void))completion {
    placeholderImage = placeholderImage?: self.image;
    [self sd_setImageWithURL:[NSURL URLWithString:path relativeToURL:[NSURL URLWithString:APIURLAssetsBase]] placeholderImage:placeholderImage completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        if (completion) {
            completion();
        }
    }];
}


@end
