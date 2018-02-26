/*!
    MBListDateItem

    Copyright © 2015-2016 Beijing ZhiYun ZhiYuan Information Technology Co., Ltd.
    https://github.com/Chinamobo/iOS-Project-Template

    Apache License, Version 2.0
    http://www.apache.org/licenses/LICENSE-2.0
 */

#import "MBModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface MBListDataItem<ObjectType> : NSObject <
    MBModel
>

@property (nonatomic, nullable, strong) ObjectType item;
@property (nonatomic, strong) NSString *cellReuseIdentifier;

+ (instancetype)dataItemWithItem:(nullable ObjectType)item cellReuseIdentifier:(NSString *)identifier;

@end

@interface MBListSectionDataItem<SectionType, RowType> : NSObject

@property (nonatomic, nullable, strong) SectionType sectionItem;
@property (nonatomic, strong) NSString *sectionIndicator;
@property (nonatomic, strong) NSMutableArray<MBListDataItem<RowType> *> *rows;

+ (instancetype)dataItemWithSectionItem:(nullable SectionType)sectionItem sectionIndicator:(NSString *)sectionIndicator rows:(NSMutableArray<MBListDataItem<RowType> *> *)rows;

@end

void MBListDataItemAddToItems(NSString *cellIdentifier, id __nullable item, NSMutableArray *items);

NS_ASSUME_NONNULL_END
