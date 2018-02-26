/*!
    MBGeneralListDisplaying

    Copyright © 2016 Beijing ZhiYun ZhiYuan Information Technology Co., Ltd.
    https://github.com/BB9z/iOS-Project-Template

    Apache License, Version 2.0
    http://www.apache.org/licenses/LICENSE-2.0
 */
#import "Common.h"

/*!
 统一的列表界面
 */

@protocol MBGeneralListDisplaying <NSObject>
@optional

- (id)listView;

- (void)refresh;

@end
