/*!
    MBListDateItem

    Copyright © 2015-2016 Beijing ZhiYun ZhiYuan Information Technology Co., Ltd.
    https://github.com/Chinamobo/iOS-Project-Template

    Apache License, Version 2.0
    http://www.apache.org/licenses/LICENSE-2.0
 */
#import <Foundation/Foundation.h>
#import "MBModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface MBListDateItem : NSObject <
    MBModel
>
@property (nonatomic, nullable, strong) id item;
@property (nonatomic, copy) NSString *cellReuseIdentifier;

+ (instancetype)dateItemWithItem:(id _Nullable)item cellReuseIdentifier:(NSString *)identifier;

@end


@interface MBListSectionDataItem : NSObject
@property (nonatomic, nullable, strong) id sectionItem;
@property (nonatomic, strong) NSMutableArray<MBListDateItem *> *rows;

+ (instancetype)dateItemWithSectionItem:(id _Nullable)sectionItem rows:(NSMutableArray<MBListDateItem *> *)rows;

@end

NS_ASSUME_NONNULL_END
