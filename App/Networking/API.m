
#import "API.h"
#import "APIJSONResponseSerializer.h"
#import "SDWebImageManager.h"
#import <RFMessageManager/RFMessageManager+RFDisplay.h>
#import "CommonUI.h"

RFDefineConstString(APIErrorDomain);
NSString *const APIURLAssetsBase              = @"http://img.example.com/";

@interface API ()
@end

@implementation API

- (void)onInit {
    [super onInit];
    
    if (AppDebugConfig().allowSSLDebug) {
        // 允许外部 SSL 嗅探
        self.securityPolicy = [AFSecurityPolicy defaultPolicy];
        self.securityPolicy.allowInvalidCertificates = YES;
        self.securityPolicy.validatesDomainName = NO;
    }
    
    // 接口总体设置
    NSString *configPath = [NSBundle.mainBundle pathForResource:@"APIDefine" ofType:@"plist"];
    [self setupAPIDefineWithPlistPath:configPath];
    
    RFAPIDefineManager *dm = self.defineManager;
    dm.defaultRequestSerializer = [AFJSONRequestSerializer serializer];
    APIJSONResponseSerializer *rps = [APIJSONResponseSerializer serializer];
    rps.serverReportErrorUsingStatusCode = YES;
    dm.defaultResponseSerializer = rps;
}

#pragma mark - 通用流程

- (BOOL)generalHandlerForError:(NSError *)error withDefine:(RFAPIDefine *)define controlInfo:(RFAPIControl *)controlInfo requestOperation:(AFHTTPRequestOperation *)operation operationFailureCallback:(void (^)(AFHTTPRequestOperation *, NSError *))operationFailureCallback {
    
    error = [self.class transformNSURLError:error];
    if (!define || [define.path hasPrefix:@"http"]) {
        // 没有 define 或 define 里写的绝对路径，意味着不是我们主要的业务逻辑
        if (operationFailureCallback) {
            operationFailureCallback(operation, error);
        }
        else {
            [self.networkActivityIndicatorManager alertError:error title:nil];
        }
        return NO;
    }
    
    if ([error.domain isEqualToString:NSURLErrorDomain]) {
        // 特殊情况，清除缓存
        if (error.code == NSURLErrorCannotParseResponse) {
            // 移除不能解析请求的缓存
            // 移除单个请求的貌似没效果
            [NSURLCache.sharedURLCache removeAllCachedResponses];
        }
    } // END: NSURLErrorDomain 下错误处理
    
    if ([error.domain isEqualToString:APIErrorDomain]) {
        // 根据业务做统一处理，比如 token 失效登出
        switch (error.code) {
//            case token_invald: {
//                if (APUser.currentUser) {
//                    APUser.currentUser = nil;
//                    [AppHUD() showErrorStatus:@"已登出，请重新登录"];
//                }
//                APUser.currentUser = nil;
//                return NO;
//            }
        }
    }
    
    //- 最终处理，报告错误
    if (operationFailureCallback) {
        operationFailureCallback(operation, error);
    }
    else {
        [self.networkActivityIndicatorManager alertError:error title:nil];
    }
    return NO;  // 需要为 NO，终止默认的错误处理
}

/// 重新包装系统错误
+ (NSError *)transformNSURLError:(NSError *)error {
    if (![error.domain isEqualToString:NSURLErrorDomain]) return error;
    
    NSString *msg = nil;
#define _Error(NAME)\
    NAME:\
        msg = NSLocalizedString(@#NAME, nil);\
        break
    
    switch (error.code) {
        case _Error(NSURLErrorCannotConnectToHost);
        case _Error(NSURLErrorCannotFindHost);
        case _Error(NSURLErrorCannotParseResponse);
        case _Error(NSURLErrorDNSLookupFailed);
        case _Error(NSURLErrorNetworkConnectionLost);
        case _Error(NSURLErrorNotConnectedToInternet);
        case _Error(NSURLErrorSecureConnectionFailed);
        case _Error(NSURLErrorTimedOut);
    }
    if (msg) {
        return [NSError errorWithDomain:error.domain code:error.code localizedDescription:msg];
    }
    return error;
}

- (BOOL)isSuccessResponse:(__strong id  _Nullable *)responseObjectRef error:(NSError *__autoreleasing  _Nullable *)error {
    // TODO: 判断是否是成功响应
    return YES;
}

#pragma mark - 具体业务

@end


void (^APIEmptyFailureHandler)(id, NSError *) = ^(id o, NSError *e) {
};
void (^APILogFailureHandler)(id, NSError *) = ^(id o, NSError *e) {
    dout_error(@"%@", e);
};
void (^APISlientFailureHandler(BOOL logError))(id, NSError *)
{
    if (logError) {
        return APIEmptyFailureHandler;
    } else {
        return APILogFailureHandler;
    }
}

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
