
#import "API+FileUpload.h"
#import <RFKit/NSError+RFKit.h>

@implementation API (MBFileUpload)

- (id<MBFileUploadTask>)uploadImageWithData:(NSData *)jpegData callback:(MBGeneralCallback)callback {
    NSParameterAssert(jpegData);
    NSParameterAssert(callback);
    return (id<MBFileUploadTask>)[self requestWithName:@"Upload" context:^(RFAPIRequestConext *c) {
        c.formData = ^(id<AFMultipartFormData> formData) {
            [formData appendPartWithFileData:jpegData name:@"file" fileName:@"image" mimeType:@"image/jpeg"];
        };
        c.combinedComplation = ^(id<RFAPITask>  _Nullable task, id  _Nullable responseObject, NSError * _Nullable error) {
            [self.class _handleFileUploadCallback:callback rsp:responseObject error:error];
        };
    }];
}

- (id<MBFileUploadTask>)uploadFile:(NSURL *)fileURL callback:(MBGeneralCallback)callback {
    NSParameterAssert(fileURL);
    NSParameterAssert(callback);
    return (id<MBFileUploadTask>)[self requestWithName:@"Upload" context:^(RFAPIRequestConext *c) {
        c.formData = ^(id<AFMultipartFormData> formData) {
            [formData appendPartWithFileURL:fileURL name:@"file" error:nil];
        };
        c.combinedComplation = ^(id<RFAPITask>  _Nullable task, id  _Nullable responseObject, NSError * _Nullable error) {
            [self.class _handleFileUploadCallback:callback rsp:responseObject error:error];
        };
    }];
}

+ (void)_handleFileUploadCallback:(MBGeneralCallback)callback rsp:(id)responseObject error:(NSError *)error {
    if (error) {
        callback(NO, nil, error);
        return;
    }
    if (![responseObject isKindOfClass:NSDictionary.class]) {
        callback(NO, nil, [NSError errorWithDomain:APIErrorDomain code:0 localizedDescription:@"返回结构异常"]);
        return;
    }
    NSString *path = responseObject[@"url"];
    if (![path isKindOfClass:NSString.class]) {
        callback(NO, nil, [NSError errorWithDomain:APIErrorDomain code:0 localizedDescription:@"路径字段类型异常"]);
        return;
    }
    NSURL *url = [NSURL.alloc initWithString:path];
    if (!url) {
        callback(NO, nil, [NSError errorWithDomain:APIErrorDomain code:0 localizedDescription:@"路径字段非法"]);
        return;
    }
    callback(YES, url, nil);
}

@end
