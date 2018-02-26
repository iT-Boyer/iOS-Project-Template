//
//  MBDebugGuardSetValueForUndefinedKey.h
//  Feel
//
//  Created by BB9z on 4/5/16.
//  Copyright © 2016 Beijing ZhiYun ZhiYuan Technology Co., Ltd. All rights reserved.
//

#import "Common.h"

/*!
 Storyboard 中设置了类不支持的 user defined runtime atrributes 在 iOS 8 之后不会崩溃，
 会有个运行警告。但是似乎总有人视警告而不见，那把这个弄明显点吧。
 */

#if RFDEBUG

@interface UIView (MBDebugGuardSetValueForUndefinedKey)

@end


@interface UIViewController (MBDebugGuardSetValueForUndefinedKey)

@end

#endif
