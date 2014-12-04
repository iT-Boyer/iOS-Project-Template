
#import "GitHubDemoResponseSerializer.h"

@interface GitHubDemoResponseSerializer ()
@end

@implementation GitHubDemoResponseSerializer

+ (instancetype)serializer {
    GitHubDemoResponseSerializer *serializer = [[self alloc] init];
    return serializer;
}

- (id)responseObjectForResponse:(NSURLResponse *)response data:(NSData *)data error:(NSError *__autoreleasing *)error {
    id responseObject = [super responseObjectForResponse:response data:data error:error];
    if (!responseObject) {
        return nil;
    }

    // 只要 items 里面的内容，其他信息丢弃了
    // 简化实现，不检查类型直接取出
    return responseObject[@"items"];
}

@end
