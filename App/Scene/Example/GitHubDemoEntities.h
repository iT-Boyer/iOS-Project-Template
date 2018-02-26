//
//  GitHubDemoEntities.h
//  App
//
//  Created by BB9z on 12/4/14.
//  Copyright (c) 2014 Chinamobo. All rights reserved.
//

#import "RFRuntime.h"
#import "JSONModel.h"

/**
 Demo 用，搜索仓库
 
 简化只处理了几个字段，详细见文档：https://developer.github.com/v3/search/#search-repositories
 */
@interface GHDRepositoryEntity : JSONModel
@property (assign, nonatomic) int uid;

@property (strong, nonatomic) NSString *name;
@property (strong, nonatomic) NSString *descriptionText;

/// 网页链接
@property (strong, nonatomic) NSURL *pageURL;
@end
