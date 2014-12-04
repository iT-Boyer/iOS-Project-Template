
#import "MBListDataSource.h"
#import "API.h"

@interface MBListDataSource ()
@property (readwrite) BOOL fetching;
@property (weak, nonatomic) NSOperation *fetchOperation;
@end

@implementation MBListDataSource

- (void)onInit {
    [super onInit];
    self.pageSize = APIConfigFetchPageSize;
    self.items = [NSMutableArray array];
    self.maxIDParameterName = @"MAX_ID";
    self.pageParameterName = @"page";
    self.pageSizeParameterName = @"page_size";
}

- (id)itemAtIndexPath:(NSIndexPath *)indexPath {
    return self.items[indexPath.row];
}

- (NSIndexPath *)indexPathForItem:(id)item {
    NSInteger idx = [self.items indexOfObject:item];
    if (idx != NSNotFound) {
        return [NSIndexPath indexPathForRow:idx inSection:0];
    }
    return nil;
}

- (void)fetchItemsFromViewController:(id)viewController nextPage:(BOOL)nextPage success:(void (^)(MBListDataSource *dateSource, NSArray *fetchedItems))success completion:(void (^)(MBListDataSource *dateSource))completion {
    if (self.fetching) return;
    self.fetching = YES;

    // Reload from top, reset properties.
    if (!nextPage) {
        self.pageEnd = NO;
    }

    self.page = nextPage? self.page + 1 : 1;
    NSMutableDictionary *dic = self.fetchParameters? (id)self.fetchParameters : [NSMutableDictionary new];
    if ([dic respondsToSelector:@selector(addEntriesFromDictionary:)]) {
        if (self.pageStyle == MBDataSourceMAXIDPageStyle) {
            if (nextPage) {
                id item = self.items.lastObject;
                RFAssert(self.maxIDKeypath, @"MAX_ID keypath 未设置");
                self.maxID = [item valueForKey:self.maxIDKeypath];
                if (self.maxID) {
                    dic[self.maxIDParameterName] = self.maxID;
                }
            }
        }
        else {
            dic[self.pageParameterName] = @(self.page);
        }
        dic[self.pageSizeParameterName] = @(self.pageSize);
    }

    if (!self.fetchAPIName) {
        dout_warning(@"Datasource 的 fetchAPIName 未设置")
        return;
    }

    @weakify(self);
    self.fetchOperation = [API requestWithName:self.fetchAPIName parameters:dic viewController:viewController forceLoad:NO loadingMessage:nil modal:NO success:^(AFHTTPRequestOperation *operation, NSArray *responseObject) {
        @strongify(self);
        if (!self) return;

        NSMutableArray *items = self.items;

        if (self.processItems) {
            responseObject = self.processItems(nextPage? [items copy] : nil, responseObject);
        }

        if (!nextPage) {
            [items removeAllObjects];
        }

        [responseObject enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            if (![items containsObject:obj]) {
                [items addObject:obj];
                return;
            }

            // 处理重复
            if (self.distinctRule == MBDataSourceDistinctRuleIgnore) {
            }
            else if (self.distinctRule == MBDataSourceDistinctRuleUpdate) {
                items[[items indexOfObject:obj]] = obj;
            }
            else if (self.distinctRule == MBDataSourceDistinctRuleReplace) {
                [items removeObject:obj];
                [items addObject:obj];
            }
            else {
                [items addObject:obj];
            }
        }];

        self.empty = (items.count == 0 && responseObject.count == 0);
        if (self.pageEndDetectPolicy == MBDataSourcePageEndDetectPolicyEmpty) {
            self.pageEnd = !!(responseObject.count == 0);
        }
        else {
            self.pageEnd = (responseObject.count < self.pageSize);
        }

        if (success) {
            success(self, responseObject);
        }
        self.hasSuccessFetched = YES;
    } failure:nil completion:^(AFHTTPRequestOperation *operation) {
        @strongify(self);
        self.fetching = NO;
        if (completion) {
            completion(self);
        }
    }];
}

- (void)prepareForReuse {
    [self.items removeAllObjects];
    self.empty = NO;
    self.page = 0;
    self.maxID = nil;
    self.pageEnd = NO;
    self.fetching = NO;
    [self.fetchOperation cancel];
}

@end
