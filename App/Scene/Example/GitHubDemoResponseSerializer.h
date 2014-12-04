//
//  GitHubDemoResponseSerializer.h
//  App
//
//  Created by BB9z on 12/4/14.
//  Copyright (c) 2014 Chinamobo. All rights reserved.
//

#import "AFURLResponseSerialization.h"

/**
 GitHub 接口演示解析器
 
 只做了最简单的实现，没有进行任何特殊情况的处理
 一个完整的处理可参看 APIJSONResponseSerializer，即使使用 APIJSONResponseSerializer 也许要根据实际接口不同做相应改写
 */
@interface GitHubDemoResponseSerializer : AFJSONResponseSerializer

@end
