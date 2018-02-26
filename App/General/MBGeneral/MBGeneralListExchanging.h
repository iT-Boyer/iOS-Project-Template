/*!
    MBGeneralListExchanging

    Copyright © 2016 Beijing ZhiYun ZhiYuan Information Technology Co., Ltd.
    https://github.com/BB9z/iOS-Project-Template

    Apache License, Version 2.0
    http://www.apache.org/licenses/LICENSE-2.0
 */
#import "Common.h"


/**
 
 */
@protocol MBGeneralListItemExchanging <NSObject>
@optional
@property (nonatomic, nullable, strong) NSArray *items;
@end


/**
 可选协议，标明 sender 有 item 属性

 一般用在 cell 上
 */
@protocol MBSenderEntityExchanging <NSObject>
@required
@property (nonatomic, nullable, strong) id item;

@optional
- (void)setItem:(id _Nullable)item offscreenRendering:(BOOL)offscreenRendering;

@end


/**
 
 */
@protocol MBGeneralListExchanging <NSObject>

@optional

+ (nullable id)itemFromSender:(nullable id)sender;

@end

#if !TARGET_OS_WATCH

@interface UITableViewCell (MBGeneralListExchanging) <
    MBGeneralListExchanging
>
@end

@interface UICollectionViewCell (MBGeneralListExchanging) <
    MBGeneralListExchanging
>
@end

#endif // !TARGET_OS_WATCH


