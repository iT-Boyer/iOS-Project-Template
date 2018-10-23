
#import "MBListDataSource.h"
#import <RFAlpha/RFCallbackControl.h>
#import <RFKit/NSArray+RFKit.h>
#import <MBAppKit/MBAppKit.h>
#import <MBAppKit/MBAPI.h>

/// 控制分页从几开始算
static const NSInteger _MBListDataSourcePageStart = 1;

@interface MBListDataSourceFetchComplationCallback : RFCallback
@end

@interface MBListDataSource ()
@property BOOL fetching;
@property (weak) NSOperation *fetchOperation;
@property (nonatomic) RFCallbackControl<MBListDataSourceFetchComplationCallback *> *fetchComplationCallbacks;
@end

@implementation MBListDataSource

- (void)onInit {
    [super onInit];
    self.pageSize = 10;
    self.items = [NSMutableArray array];
    self.maxIDParameterName = @"MAX_ID";
    self.pageParameterName = @"page";
    self.pageSizeParameterName = @"per_page";
    self.pageEndDetectPolicy = MBDataSourcePageEndDetectPolicyStrict;
}

- (void)prepareForReuse {
    [self.items removeAllObjects];
    self.empty = NO;
    self.page = _MBListDataSourcePageStart - 1;
    self.maxID = nil;
    self.pageEnd = NO;
    self.fetching = NO;
    [self.fetchOperation cancel];
}

- (id)itemAtIndexPath:(NSIndexPath *)indexPath {
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
    if (!self.fetchAPIName) {
        dout_warning(@"Datasource 的 fetchAPIName 未设置")
        return;
    }
    self.fetching = YES;

    // Reload from top, reset properties.
    if (!nextPage) {
        self.pageEnd = NO;
        self.maxID = nil;
    }

    self.page = nextPage? self.page + 1 : _MBListDataSourcePageStart;
    BOOL pagingEnabled = !self.pagingDisabled;
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

    @weakify(self);
    __block BOOL operationSuccess = NO;
    self.fetchOperation = [MBAPI requestWithName:self.fetchAPIName parameters:parameter viewController:viewController forceLoad:NO loadingMessage:nil modal:NO success:^(AFHTTPRequestOperation *operation, id responseObject) {
        operationSuccess = YES;
        @strongify(self);
        if (!self) return;

        NSMutableArray *items = self.items;
        NSArray *responseArray = nil;
        if (self.processItems) {
            responseArray = self.processItems(nextPage? items.copy : nil, responseObject);
        }
        else if ([responseObject isKindOfClass:NSArray.class]) {
            responseArray = responseObject;
        }
        
        if (!nextPage) {
            [items removeAllObjects];
        }
        [self _MBListDataSource_handleResponseArray:responseArray items:items];
        if (!pagingEnabled) {
            self.pageEnd = YES;
        }
        if (success) {
            success(self, responseArray);
        }
        self.hasSuccessFetched = YES;
        self.lastFetchError = nil;
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        @strongify(self);
        if (!self) return;
        
        self.lastFetchError = error;
        BOOL (^cb)(MBListDataSource *, NSError *) = self.class.defaultFetchFailureHandler;
        if (cb && cb(self, error)) {
            return;
        }
    } completion:^(AFHTTPRequestOperation *operation) {
        @strongify(self);
        if (!self) return;

        if (!operationSuccess) {
            // 请求失败的话分页应该减回去
            self.page--;
        }
        self.fetching = NO;
        if (completion) {
            completion(self);
        }
        [self.fetchComplationCallbacks performWithSource:self filter:nil];
    }];
}

- (void)setItemsWithRawData:(id)responseData {
    self.fetching = NO;
    [self.fetchOperation cancel];
    self.page = 0;
    self.maxID = nil;
    
    NSMutableArray *items = self.items;
    [items removeAllObjects];
    NSArray *responseArray = nil;
    if (self.processItems) {
        responseArray = self.processItems(nil, responseData);
    }
    else if ([responseData isKindOfClass:NSArray.class]) {
        responseArray = responseData;
    }
    
    [self _MBListDataSource_handleResponseArray:responseArray items:items];
    self.pageEnd = YES;
    self.hasSuccessFetched = YES;
    self.lastFetchError = nil;
}

- (void)_MBListDataSource_handleResponseArray:(NSArray *)responseArray items:(NSMutableArray *)items {
    [responseArray enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        // Swift array may contains nil
        if (!obj) return;
        
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
}

#pragma mark -

static id _defaultFetchFailureHandler = nil;
+ (BOOL (^)(MBListDataSource * _Nonnull, NSError * _Nonnull))defaultFetchFailureHandler {
    return _defaultFetchFailureHandler;
}
+ (void)setDefaultFetchFailureHandler:(BOOL (^)(MBListDataSource * _Nonnull, NSError * _Nonnull))defaultFetchFailureHandler {
    _defaultFetchFailureHandler = defaultFetchFailureHandler;
}

- (RFCallbackControl *)fetchComplationCallbacks {
    if (_fetchComplationCallbacks) return _fetchComplationCallbacks;
    RFCallbackControl *c = RFCallbackControl.new;
    c.objectClass = MBListDataSourceFetchComplationCallback.class;
    _fetchComplationCallbacks = c;
    return _fetchComplationCallbacks;
}

- (void)addFetchComplationCallback:(void (^)(__kindof MBListDataSource * _Nonnull, NSError * _Nullable))callback refrenceObject:(id)object {
    [self.fetchComplationCallbacks addCallback:callback refrenceObject:object];
}

- (void)removeFetchComplationCallbacksOnRefrenceObject:(id)object {
    [self.fetchComplationCallbacks removeCallbackOfRefrenceObject:object];
}

@end

@implementation MBListDataSourceFetchComplationCallback

- (void)perfromBlock:(nonnull id)block source:(MBListDataSource *)source {
    void (^cb)(__kindof MBListDataSource *__nonnull ds, NSError *__nullable error) = block;
    cb(source, source.lastFetchError);
}

@end
