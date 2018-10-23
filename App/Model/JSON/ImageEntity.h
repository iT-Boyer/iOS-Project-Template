/*
 ImageEntity
 
 Copyright © 2018 RFUI.
 Copyright © 2014-2016 Beijing ZhiYun ZhiYuan Technology Co., Ltd.
 https://github.com/BB9z/iOS-Project-Template
 
 Apache License, Version 2.0
 http://www.apache.org/licenses/LICENSE-2.0
 */

#import <MBAppKit/MBAppKit.h>

/**
 带比例信息的图片结构
 */
@interface ImageEntity : MBModel
@property (nonnull) NSString *url;
@property (nonatomic) double sizeRatio;

+ (nullable NSURL *)resizedImageURLWithURLString:(nullable NSString *)path preferringView:(nonnull UIView *)view;

/// 返回一个不大于需求尺寸的缩略图
+ (void)fetchCahcedImageWithImagePath:(nullable NSString *)imagePath preferredPixelWidth:(CGFloat)preferredPixelWidth complation:(nonnull void (^)(UIImage *__nullable image))complation;
+ (CGFloat)pixelWidthOfView:(nonnull UIView *)view;

+ (void)fetchImageWithPath:(nullable NSString *)imagePath complation:(nullable MBGeneralCallback)complation;

@end

@protocol ImageEntity <NSObject>
@end
