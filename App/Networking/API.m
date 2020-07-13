
#import "API.h"
#import "APIJSONResponseSerializer.h"
#import "Common.h"
#import "NSUserDefaults+MBDebug.h"
#import <AFNetworking/AFSecurityPolicy.h>
#import <RFAPI/RFAPIJSONModelTransformer.h>
#import <RFMessageManager/RFMessageManager+RFDisplay.h>
#import <SDWebImage/SDWebImageManager.h>

RFDefineConstString(APIErrorDomain);
NSString *const APIURLAssetsBase              = @"http://img.example.com/";

@interface API ()
@end

@implementation API

- (void)onInit {
    [super onInit];
    
    if (NSUserDefaults.standardUserDefaults._debugAPIAllowSSLDebug) {
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

    // 针对演示用接口做的调整，正式项目请移除这部分代码
    if ([dm.defaultDefine.baseURL.host isEqualToString:@"bb9z.github.io"]) {
        // 演示接口只支持 GET 方法，且需要附加 JSON 后缀
        for (RFAPIDefine *define in dm.defines) {
            // 非相对路径，意味着是外部接口，跳过
            if ([define.path hasPrefix:@"http"]) continue;
            if (define.responseExpectType == RFAPIDefineResponseExpectObjects) {
                // 列表请求，改造分页参数
                define.path = [define.path stringByAppendingPathComponent:@"{page}"];
            }
            define.path = [define.path stringByAppendingPathExtension:@"json"];
            define.method = @"GET";
        }
    }
    else {
        dout_warning(@"⚠️ 请移除演示代码 %s %s", __FILE__, __FUNCTION__)
    }

    self.modelTransformer = RFAPIJSONModelTransformer.new;
}

#pragma mark - 通用流程

- (BOOL)generalHandlerForError:(NSError *)error withDefine:(RFAPIDefine *)define task:(id<RFAPITask>)task failureCallback:(RFAPIRequestFailureCallback)failure {
    // @bug(RFAPI: beta1): 没有在 completionQueue 调用
    // @bug(RFAPI: beta1): 取消没有过滤
    if (error.code == NSURLErrorCancelled) {
        return NO;
    }
    error = [self.class transformNSURLError:error];
    if (!define || [define.path hasPrefix:@"http"]) {
        // 没有 define 或 define 里写的绝对路径，意味着不是我们主要的业务逻辑
        dispatch_async_on_main(^{
            if (failure) {
                failure(task, error);
            }
            else {
                [self.networkActivityIndicatorManager alertError:error title:nil fallbackMessage:@"请求失败"];
            }
        });
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
//                if (Account.currentUser) {
//                    Account.currentUser = nil;
//                    [AppHUD() showErrorStatus:@"已登出，请重新登录"];
//                }
//                Account.currentUser = nil;
//                return NO;
//            }
        }
    }
    
    //- 最终处理，报告错误
    dispatch_async_on_main(^{
        if (failure) {
            failure(task, error);
        }
        else {
            [self.networkActivityIndicatorManager alertError:error title:nil fallbackMessage:@"请求失败"];
        }
    });
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

#import <SDWebImage/UIImageView+WebCache.h>

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
