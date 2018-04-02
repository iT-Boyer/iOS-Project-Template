
#import "MBListDataSource.h"
#import "API.h"
#import "APINetworkActivityManager.h"
#import "MBModel.h"
#import "MBNavigationController.h"

@interface MBListDataSource ()
@property (readwrite) BOOL fetching;
@property (weak, nonatomic) NSOperation *fetchOperation;
@end

@implementation MBListDataSource

- (void)onInit {
    [super onInit];
    self.pageSize = 10;
    self.items = [NSMutableArray array];
    self.maxIDParameterName = @"MAX_ID";
    self.pageParameterName = @"page";
    self.pageSizeParameterName = @"page_size";
}

- (nonnull id)itemAtIndexPath:(nonnull NSIndexPath *)indexPath {
    return [self.items rf_objectAtIndex:indexPath.row];
}

- (nullable NSIndexPath *)indexPathForItem:(nullable id)item {
    NSInteger idx = [self.items indexOfObject:item];
    if (idx != NSNotFound) {
        return [NSIndexPath indexPathForRow:idx inSection:0];
    }
    return nil;
}

- (nonnull NSArray *)itemsForindexPaths:(nonnull NSArray *)indexPaths {
    NSMutableArray *items = [NSMutableArray arrayWithCapacity:indexPaths.count];
    for (NSIndexPath *ip in indexPaths) {
        [items rf_addObject:[self itemAtIndexPath:ip]];
    }
    return items;
}

- (void)fetchItemsFromViewController:(nullable id)viewController nextPage:(BOOL)nextPage success:(void (^)(__kindof MBListDataSource *dateSource, NSArray *fetchedItems))success completion:(void (^)(__kindof MBListDataSource *dateSource))completion {
    if (self.fetching) return;
    self.fetching = YES;

    // Reload from top, reset properties.
    if (!nextPage) {
        self.pageEnd = NO;
        self.maxID = nil;
    }

    self.page = nextPage? self.page + 1 : 1;
    BOOL pagingEnabled = !self.fetchParameters || [self.fetchParameters respondsToSelector:@selector(addEntriesFromDictionary:)];
    NSMutableDictionary *parameter = [NSMutableDictionary dictionaryWithDictionary:self.fetchParameters];
    if (pagingEnabled) {
        if (self.pageStyle == MBDataSourceMAXIDPageStyle) {
            if (nextPage) {
                id item = self.items.lastObject;
                RFAssert(self.maxIDKeypath, @"MAX_ID keypath 未设置");
                self.maxID = [item valueForKey:self.maxIDKeypath];
                if (self.maxID) {
                    parameter[self.maxIDParameterName] = self.maxID;
                }
            }
        }
        else {
            parameter[self.pageParameterName] = @(self.page);
        }
        parameter[self.pageSizeParameterName] = @(self.pageSize);
    }

    if (!self.fetchAPIName) {
        dout_warning(@"Datasource 的 fetchAPIName 未设置")
        return;
    }

    @weakify(self);
    __block BOOL operationSuccess = NO;
    self.fetchOperation = [API requestWithName:self.fetchAPIName parameters:parameter viewController:viewController forceLoad:NO loadingMessage:nil modal:NO success:^(AFHTTPRequestOperation *operation, id responseObject) {
        operationSuccess = YES;
        @strongify(self);
        if (!self) return;

        NSMutableArray *items = self.items;
        NSArray *responseArray = [responseObject isKindOfClass:[NSArray class]]? responseObject : nil;
        if (self.processItems) {
            responseArray = self.processItems(nextPage? [items copy] : nil, responseObject);
        }

        if (!nextPage) {
            [items removeAllObjects];
        }

        [responseArray enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            // Ignored
            if ([obj respondsToSelector:@selector(ignored)]) {
                if ([(id<MBModel>)obj ignored]) {
                    return;
                }
            }

            // 不重复，直接加
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

        self.empty = (items.count == 0 && responseArray.count == 0);
        if (self.pageEndDetectPolicy == MBDataSourcePageEndDetectPolicyEmpty) {
            self.pageEnd = !!(responseArray.count == 0);
        }
        else {
            self.pageEnd = (responseArray.count < self.pageSize);
        }
        if (!pagingEnabled) {
            self.pageEnd = YES;
        }

        if (success) {
            success(self, responseArray);
        }
        self.hasSuccessFetched = YES;
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        // 超时不产生反应
        @strongify(self);
        if ([error.domain isEqualToString:NSURLErrorDomain]
            && error.code == NSURLErrorTimedOut) {
            return;
        }

        // 404 弹出
        if ([error.domain isEqualToString:APIErrorDomain] && error.code == 404) {
            [AppNavigationController() popViewControllerAnimated:YES];
        }

        [AppHUD() alertError:error title:nil];
        
        if (self.fetchDataFailure) {
            self.fetchDataFailure(self, error);
        }
    } completion:^(AFHTTPRequestOperation *operation) {
        @strongify(self);
        if (!operationSuccess) {
            // 请求失败的话分页应该减回去
            self.page--;
        }
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
