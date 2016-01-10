/*!
    MBEntityExchanging
    v 0.4

    Copyright © 2014 Beijing ZhiYun ZhiYuan Information Technology Co., Ltd.
    Copyright © 2014 Chinamobo Co., Ltd.
    https://github.com/Chinamobo/iOS-Project-Template

    Apache License, Version 2.0
    http://www.apache.org/licenses/LICENSE-2.0
 */

#import <Foundation/Foundation.h>

/**
 标准视图间 model 交换协议
 
 分成两部分，一是更新界面的规则，二是更新数据的规则。
 可选的是本身会有一个 model 属性或 model 集合的属性

 具体见下面协议方法的说明
 */
@protocol MBEntityExchanging <NSObject>

@optional

@property (nonatomic, nullable, strong) id item;
@property (nonatomic, nullable, strong) NSArray *items;

#pragma mark - 界面更新

/** 
 更新界面操作

 子类应该在开头调用 super
 */
- (void)updateUIForItem;

/**
 标记 model 更新了，需要刷新界面
 */
- (void)setNeedsUpdateUIForItem;

/**
 尝试立即更新界面，如果没有标记需要更新则不会更新

 默认会在 viewDidAppear: 时执行
 */
- (void)updateUIForItemIfNeeded;

#pragma mark - 数据获取

/**
 获取数据操作

 子类应该在结尾调用 super，默认实现不触发界面更新
 */
- (void)updateItem;

/**
 标记需要重新获取 Item
 */
- (void)setNeedsUpdateItem;

/**
 尝试立即获取新数据，如果没有标记需要更新则不会执行

 默认会在 viewDidAppear: 时执行
 */
- (void)updateItemIfNeeded;

@end


#pragma mark - Cell

/**
 可选协议，标明 sender 有 item 属性
 
 一般用在 cell 上
 */
@protocol MBSenderEntityExchanging <NSObject>
@required
@property (nonatomic, nullable, strong) id item;

@optional
- (void)setItem:(id _Nullable)item offscreenRendering:(BOOL)offscreenRendering;

- (void)onCellSelected;
@end

/**
 item 的可选协议
 */
@protocol MBItemExchanging <NSObject>
@optional
- (NSString *_Nullable)displayString;
@end


@protocol MBEntityCellExchanging <NSObject>
@optional

/**
 一般在 table view cell 或 collection view cell 上实现
 
 delegate 在实现时先检查其返回值，如果是 YES 不继续执行 delegate 的后续逻辑
 */
- (BOOL)respondsCellSelection;

@end


#pragma mark - Segue

/**
 TEST
 
 用在 unwind segue 的 sourceViewController 上
 然后在 destinationViewController 的 IBAction 中取道传过来的量
 */
@protocol MBUnwindSegueExchanging <NSObject>
@optional
@property (nonatomic) NSKeyValueChange unwindChangeType;
@property (nonatomic, nullable, strong) id unwindChangeItem;

// destinationViewController 推荐 IBAction 方法名
// - (IBAction)MBReturnWithUnwindSegue:(UIStoryboardSegue *)segue;
@end

/**
 TEST
 
 跟 MBUnwindSegueExchanging 相反

 destinationViewController 实现这些属性，在 sourceViewController 中先拿到 destinationViewController 实例并设置这些属性，然后执行返回

 之后 destinationViewController 在显示前（通常是 viewWillApear 中）更新界面
 */
@protocol MBEntityReturnExchanging <NSObject>
@optional
@property (nonatomic) NSKeyValueChange unwindChangeType;
@property (nonatomic, nullable, strong) id unwindChangeItem;

@end


/**
 prepareForSegue:sender: 默认传递方法

 首先检查 destinationViewController 是否可以设置 item 属性，如果可以会依次检查 sender 和 self 是否有 item 属性可以传递
 */
#define MBEntityExchangingPrepareForSegue \
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {\
    id dvc = segue.destinationViewController;\
    if ([dvc respondsToSelector:@selector(setItem:)]) {\
        if ([sender respondsToSelector:@selector(item)]) {\
            [dvc setItem:[(id<MBEntityExchanging>)sender item]];\
        }\
        else if ([self respondsToSelector:@selector(item)]) {\
            [dvc setItem:[(id<MBEntityExchanging>)self item]];\
        }\
    }\
}

#define MBEntityExchangingPrepareForTableViewSegue \
    - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {\
        id dvc = segue.destinationViewController;\
        if ([dvc respondsToSelector:@selector(setItem:)]) {\
            id item;\
            if ([sender respondsToSelector:@selector(item)]) {\
                item = [(id<MBEntityExchanging>)sender item];\
            }\
            else {\
                id<MBEntityExchanging> cell = (id)[sender superviewOfClass:[self class]];\
                if ([cell respondsToSelector:@selector(item)]) {\
                    item = cell;\
                }\
            }\
            if (!item && [self respondsToSelector:@selector(item)]) {\
                item = [(id<MBEntityExchanging>)self item];\
            }\
            [dvc setItem:item];\
        }\
    }


#pragma mark - Callback

/**
 一般的异步请求数据回调
 
 success 表示成功、失败，取消也算失败。失败时 error 不应为空
 
 一般如下处理：
 
 @code
 
 ^(BOOL success, id _Nullable item, NSError *_Nullable error) {
    if (!succes) {
        if (error) {
            // 明确失败
            [UIAlertView showWithTitle:@"操作失败" message:error.localizedDescription buttonTitle:nil];
        }
        // 否则通常是取消
        return;
    }

    // 成功，使用数据
 }

 @endcode
 */
typedef void (^MBGeneralCallback)(BOOL success, id _Nullable item, NSError *_Nullable error);

/**
 使用：

 typedef MBGeneralCallback(类型名, 对象类型);
 */
#define MBGeneralCallback(TYPE_NAME, OBJ_TYPE) void (^TYPE_NAME)(BOOL success, OBJ_TYPE _Nullable item, NSError *_Nullable error);

