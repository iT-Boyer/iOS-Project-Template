
#import "MBListDateItem.h"

@interface MBListDateItem ()
@end

@implementation MBListDateItem

+ (instancetype)dateItemWithItem:(id)item cellReuseIdentifier:(NSString *)identifier {
    MBListDateItem *this = [self new];
    this.item = item;
    this.cellReuseIdentifier = identifier;
    return this;
}

- (BOOL)ignored {
    return NO;
}

- (NSString *)debugDescription {
    return [NSString stringWithFormat:@"<%@: %p, item: %@, cellReuseIdentifier: %@>", self.class, self, self.item, self.cellReuseIdentifier];
}

@end


@implementation MBListSectionDataItem

+ (instancetype)dateItemWithSectionItem:(id)sectionItem rows:(NSMutableArray<MBListDateItem *> *)rows {
    MBListSectionDataItem *this = [self new];
    this.sectionItem = sectionItem;
    this.rows = rows;
    return this;
}

- (NSString *)debugDescription {
    return [NSString stringWithFormat:@"<%@: %p, section: %@, rows: %@>", self.class, self, self.sectionItem, self.rows];
}

@end
