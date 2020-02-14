/*
 MBListDataSource
 
 Copyright © 2018 RFUI.
 Copyright © 2014-2016 Beijing ZhiYun ZhiYuan Information Technology Co., Ltd.
 https://github.com/BB9z/iOS-Project-Template
 
 Apache License, Version 2.0
 http://www.apache.org/licenses/LICENSE-2.0
 */
#import <RFDelegateChain/RFDelegateChain.h>

// @MBDependency:4
/**
 单 section 的列表 dataSource
 */
@interface MBListDataSource<ItemType> : RFDelegateChain

/**
 清空数据、重置状态，以便作为另一个列表的 dataSource 使用
 
 不会重设配置量
*/
- (void)prepareForReuse;

#pragma mark - Items

@property (nonatomic, nullable) NSMutableArray<ItemType> *items;

/// 列表为空
@property BOOL empty;

- (nullable ItemType)itemAtIndexPath:(nullable NSIndexPath *)indexPath;
- (nonnull NSArray<ItemType> *)itemsForindexPaths:(nonnull NSArray<NSIndexPath *> *)indexPaths;
- (nullable NSIndexPath *)indexPathForItem:(nullable ItemType)item;

#pragma mark - 分页

/// 禁用分页
@property BOOL pagingDisabled;

typedef NS_ENUM(short, MBDataSourcePageStyle) {
    /// 默认，把当前页数作为游标，从 1 开始计算
    MBDataSourceDefaultPageStyle = 0,

    /// 把上一页最后的 item 的 ID 作为分页游标
    MBDataSourceMAXIDPageStyle,
};

/**
 使用的分页模式，默认 MBDataSourceDefaultPageStyle
 */
@property MBDataSourcePageStyle pageStyle;

@property NSInteger page;
@property NSUInteger pageSize;

@property (nullable) id maxID;

/// maxID 的获取是通过在最后一个 item 上执行 valueForKeyPath: 获取的
@property (nullable) NSString *maxIDKeypath;

/// 默认 page
@property (nullable) NSString *pageParameterName;

/// 默认 page_size
@property (nullable) NSString *pageSizeParameterName;

/// 默认 MAX_ID
@property (nullable) NSString *maxIDParameterName;

/// 页面到底了
@property BOOL pageEnd;

/**
 判断页面到底的策略
 */
typedef NS_ENUM(short, MBDataSourcePageEndDetectPolicy) {
    /// 默认，只有返回为空时才算到底
    MBDataSourcePageEndDetectPolicyEmpty = 0,

    /// 获取数量少于 page_size 就算到底
    MBDataSourcePageEndDetectPolicyStrict
};
/// 默认 Strict
@property MBDataSourcePageEndDetectPolicy pageEndDetectPolicy;

#pragma mark - 条目获取

/// 是否正在获取数据
@property (readonly) BOOL fetching;
@property BOOL hasSuccessFetched;

@property (nullable, copy) IBInspectable NSString *fetchAPIName;
@property (nullable) NSDictionary *fetchParameters;
@property (nullable) NSError *lastFetchError;

/**
 加载数据
 
 @param nextPage 下一页还是从头加载
 @param success fetchedItems 是处理后的最终数据
 */
- (void)fetchItemsFromViewController:(nullable UIViewController *)viewController nextPage:(BOOL)nextPage success:(void (^__nullable)(__kindof MBListDataSource *__nonnull dateSource, NSArray *__nullable fetchedItems))success completion:(void (^__nullable)(__kindof MBListDataSource *__nonnull dateSource))completion;

/**
 用给定的原始数据重置列表数据，并把状态属性置为合适的值
 
 取消正在获取的数据，标记分页到底
 */
- (void)setItemsWithRawData:(nullable id)responseData;

#pragma mark - 条目处理

/**
 对网络请求返回的数据进行第一次处理，典型情形如手工去重、模型转换
 
 @param oldItems 数据源中目前存在对象的拷贝，如果是刷新获取会是 nil，获取下一页时一定是个数组
 @param newItems 请求返回的对象，有可能不是数组，这种情况有必要处理

 返回处理好的新数据的数组，之后会交由 data source 进行其他处理
 */
@property (nullable, copy) NSArray<ItemType> *__nullable (^processItems)(NSArray<ItemType> *__nullable oldItems, id __nullable newValue);

/**
 当新获取对象在数组中已存在如何操作
 */
typedef NS_ENUM(short, MBDataSourceDistinctRule) {
    MBDataSourceDistinctRuleDefault = 0,

    /// 忽略掉新对象
    MBDataSourceDistinctRuleIgnore,

    /// 用新对象替换掉旧的，不改变已有对象顺序
    MBDataSourceDistinctRuleUpdate,

    /// 用新对象替换掉旧的，对象被移动到后面
    MBDataSourceDistinctRuleReplace,
};

/**
 重复条目处理方式
 */
@property MBDataSourceDistinctRule distinctRule;

#pragma mark - 事件处理

/// 数据请求失败默认的错误处理（应用级别）
/// 返回 YES 终止错误处理流程
@property (class, nullable, nonatomic) BOOL (^defaultFetchFailureHandler)(MBListDataSource *__nonnull ds, NSError *__nonnull error);

/// 注册数据请求结束的事件处理
- (void)addFetchComplationCallback:(void (^__nonnull)(__kindof MBListDataSource *__nonnull ds, NSError *__nullable error))callback refrenceObject:(nonnull id)object;
- (void)removeFetchComplationCallbacksOnRefrenceObject:(nonnull id)object;

@end
