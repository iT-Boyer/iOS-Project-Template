
#import "debug.h"
#import "AFNetworkReachabilityManager.h"
#import "APIJSONResponseSerializer.h"
#import "APINetworkActivityManager.h"
#import "MBAnalytics.h"
#import "MBApp.h"
#import "NSData+ImageContentType.h"
#import "SDImageCache.h"
#import "SDWebImageManager.h"
#import "SVProgressHUD.h"
#import "ZYErrorCode.h"
#import "NSFileManager+RFKit.h"
#import "NSJSONSerialization+RFKit.h"
#import "UIDevice+RFKit.h"

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
        _user = up;
    }
    return _user;
}

- (AFHTTPSessionManager *)manager {
    if (!_manager) {
        AFHTTPSessionManager *m = [AFHTTPSessionManager manager];
        _manager = m;
    }
    return _manager;
}


- (void)onInit {
    [super onInit];
    
    // 接口总体设置
    NSString *configPath = [[NSBundle mainBundle] pathForResource:@"APIDefine" ofType:@"plist"];
    NSDictionary *rules = [[NSDictionary alloc] initWithContentsOfFile:configPath];
    NSMutableDictionary<NSString *, NSDictionary *> *prules = [NSMutableDictionary dictionary];
    __block NSInteger ruleCount = 0;
    [rules enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, NSDictionary * _Nonnull obj, BOOL * _Nonnull stop) {
        if ([key hasPrefix:@"@"]) {
            [prules addEntriesFromDictionary:obj];
            ruleCount += obj.count;
        }
        else {
            prules[key] = obj;
            ruleCount++;
        }
    }];
    _dout_debug(@"载入 %ld 个接口定义", ruleCount);
    RFAssert(ruleCount == prules.count, @"有规则重名了");
    
    RFAPIDefineManager *dm = self.defineManager;
    [dm setDefinesWithRulesInfo:prules];
    
    if (AppDebugConfig().allowSSLDebug) {
        // 允许外部 SSL 嗅探
        self.securityPolicy = [AFSecurityPolicy defaultPolicy];
        self.securityPolicy.allowInvalidCertificates = YES;
        self.securityPolicy.validatesDomainName = NO;
    }
    
    dm.defaultRequestSerializer = [AFJSONRequestSerializer serializer];
    APIJSONResponseSerializer *rps = [APIJSONResponseSerializer serializer];
    rps.serverReportErrorUsingStatusCode = YES;
    dm.defaultResponseSerializer = rps;
    self.maxConcurrentOperationCount = 5;
    self.responseProcessingQueue = dispatch_queue_create("API.Processing", DISPATCH_QUEUE_SERIAL);
    
    // 设置属性
    self.networkActivityIndicatorManager = [APINetworkActivityManager new];
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

+ (void)backgroundRequestWithName:(NSString *)APIName parameters:(NSDictionary *)parameters completion:(void (^)(BOOL success, id responseObject, NSError *error))completion {
    RFAPIControl *cn = [[RFAPIControl alloc] init];
    cn.identifier = APIName;
    cn.backgroundTask = YES;
    __block MBGeneralCallback safeCallback = MBSafeCallback(completion);
    [[self sharedInstance] requestWithName:APIName parameters:parameters controlInfo:cn success:^(AFHTTPRequestOperation * _Nullable operation, id  _Nullable responseObject) {
        safeCallback(YES, responseObject, nil);
        safeCallback = nil;
    } failure:^(AFHTTPRequestOperation * _Nullable operation, NSError * _Nonnull error) {
        safeCallback(NO, nil, error);
        safeCallback = nil;
    } completion:^(AFHTTPRequestOperation * _Nullable operation) {
        if (safeCallback) {
            safeCallback(NO, nil, nil);
        }
    }];
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
    return YES;
}

- (BOOL)isSuccessResponse:(__autoreleasing id *)responseObjectRef error:(NSError *__autoreleasing *)error {
    // TODO: 判断是否是成功响应
    return YES;
}

#pragma mark - 具体业务

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
