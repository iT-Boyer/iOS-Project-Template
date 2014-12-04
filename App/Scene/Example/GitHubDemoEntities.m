
#import "GitHubDemoEntities.h"

@implementation GHDRepositoryEntity

+ (JSONKeyMapper *)keyMapper {
    GHDRepositoryEntity *this;
    return [[JSONKeyMapper alloc] initWithDictionary:@{
        @"id": @keypath(this, uid),
        @"description": @keypath(this, descriptionText),
        @"html_url": @keypath(this, pageURL),
    }];
}

+ (BOOL)propertyIsOptional:(NSString *)propertyName {
    return YES;
}

@end
