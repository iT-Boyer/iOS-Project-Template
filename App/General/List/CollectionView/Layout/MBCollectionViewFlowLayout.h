/*!
    MBCollectionViewFlowLayout

    Copyright © 2014 Beijing ZhiYun ZhiYuan Information Technology Co., Ltd.
    https://github.com/Chinamobo/iOS-Project-Template

    Apache License, Version 2.0
    http://www.apache.org/licenses/LICENSE-2.0
 */

#import "Common.h"

/**
 UICollectionViewFlowLayout 等价体，修正特定版本系统的 bug
 */
@interface MBCollectionViewFlowLayout : UICollectionViewFlowLayout <
    RFInitializing
>

@end
