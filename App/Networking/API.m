
#import "API.h"
#import "debug.h"
#import "APIJSONResponseSerializer.h"
#import "SDWebImageManager.h"

RFDefineConstString(APIErrorDomain);
NSString *APIURLAssetsBase              = @"http://img.example.com/";

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
    return YES;
}

- (BOOL)isSuccessResponse:(__autoreleasing id *)responseObjectRef error:(NSError *__autoreleasing *)error {
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
