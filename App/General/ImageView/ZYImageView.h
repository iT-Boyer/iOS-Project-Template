/*!
 ZYImageView
 
 Copyright © 2018 RFUI.
 Copyright © 2016 Beijing ZhiYun ZhiYuan Technology Co., Ltd.
 https://github.com/BB9z/iOS-Project-Template
 
 Apache License, Version 2.0
 http://www.apache.org/licenses/LICENSE-2.0
 */
#import <MBAppKit/MBAppKit.h>

/**
 远程图片显示 view

 对部分默认属性进行了重设
 */
@interface ZYImageView : UIImageView <
    RFInitializing
>

/**
 请使用这个方法设置图片
 */
@property (nonatomic, nullable, copy) NSString *imageURL;

/**
 设置图片，有回调
 
 @param imageURL 为空将隐藏图片
 
 @param complation 这个回调设计是获取到图像后对图像进行额外处理准备的，只有当图片实际加载到 image view 上或获取失败时才会调用。可能会被调用多次，如有缓存图像时；还有可能根本不被调用，加载过程中又开始加载另外一张图、未加载完 view 被释放。item 是 UIImage
 */
- (void)fetchImageWithImageURL:(nullable NSString *)imageURL complete:(nullable MBGeneralCallback)complation;

/**
 占位图，awakeFromNib 时取 nib 中的设置作为默认占位符
 */
@property (nullable) IBInspectable UIImage *placeholderImage;

/**
 图像加载失败时显示的图片
 */
@property (nullable) IBInspectable UIImage *failureImage;

/**
 激活固有大小修正，强制按比例显示。默认 NO
 */
@property IBInspectable BOOL intrinsicContentSizeFixEnabled;

/**
 默认移出 window 会暂停当前下载，加回继续下载
 
 设置为 YES 以禁止该行为
 */
@property IBInspectable BOOL disableDownloadPauseWhenRemoveFromWindow;

@end
