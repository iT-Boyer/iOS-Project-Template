//
//  ImageEntity.h
//  ZNArt
//
//  Created by BB9z on 2018/5/27.
//  Copyright © 2018 znart.com. All rights reserved.
//

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
