
#import "ImageEntity.h"
#import <RFKit/UIView+RFAnimate.h>
#import <RFKit/NSError+RFKit.h>
#import <SDWebImage/SDWebImageManager.h>
#import <SDWebImage/SDImageCache.h>

@interface ImageEntity ()
@property int width;
@property int height;
@end

@implementation ImageEntity

- (double)sizeRatio {
    if (_sizeRatio > 0.1 && _sizeRatio < 10) {
        return _sizeRatio;
    }
    if (self.width > 0 && self.height > 0) {
        return (double)self.width / self.height;
    }
    return 1;
}

- (BOOL)isEqual:(id)other {
    if (other == self) {
        return YES;
    }
    if (![other isMemberOfClass:[self class]]) {
        return NO;
    }
    if (self.url && [self.url isEqualToString:[(ImageEntity *)other url]]) {
        return YES;
    }
    return NO;
}

- (NSUInteger)hash {
    return self.url.hash;
}

+ (NSURL *)resizedImageURLWithURLString:(NSString *)path preferringView:(UIView *)view {
    RFAssert(view, nil);
    return [self resizedImageURLWithURLString:path preferredPixelWidth:[self pixelWidthOfView:view]];
}

+ (nullable NSURL *)resizedImageURLWithURLString:(nullable NSString *)path preferredPixelWidth:(CGFloat)preferredWidth {
    if (!path) return nil;
    return [NSURL URLWithString:path];
}

+ (void)fetchCahcedImageWithImagePath:(NSString *)imagePath preferredPixelWidth:(CGFloat)preferredPixelWidth complation:(nonnull void (^)(UIImage *__nullable image))complation {
    dispatch_async_on_background(^{
        UIImage *lastPreviousCachedImage;
        for (NSNumber *widthObj in @[ @1080, @750, @640, @320, @160 ]) {
            CGFloat width = [widthObj floatValue];
            if (width > preferredPixelWidth) {
                // 大图略过b
                continue;
            }
            
            _dout_debug(@"Check url: %@", url)
            NSURL *url = [ImageEntity resizedImageURLWithURLString:imagePath preferredPixelWidth:width];
            NSString *key = [[SDWebImageManager sharedManager] cacheKeyForURL:url];
            lastPreviousCachedImage = [[SDImageCache sharedImageCache] imageFromDiskCacheForKey:key];
            if (lastPreviousCachedImage) {
                _dout_debug(@"Found cache image %@", url);
                break;
            }
        }
        dispatch_async_on_main(^{
            complation(lastPreviousCachedImage);
        });
    });
}

+ (CGFloat)pixelWidthOfView:(UIView *)view {
    CGFloat scale = view.window.screen.scale;
    if (!scale) {
        scale = [UIScreen mainScreen].scale;
    }
    return view.width * scale;
}

+ (void)fetchImageWithPath:(NSString *)imagePath complation:(MBGeneralCallback)complation {
    NSURL *url = [NSURL URLWithString:imagePath];
    MBGeneralCallback cb = MBSafeCallback(complation);
    if (!url) {
        cb(NO, nil, [NSError errorWithDomain:self.className code:0 localizedDescription:@"图片地址无效"]);
        return;
    }
    [SDWebImageManager.sharedManager loadImageWithURL:url options:SDWebImageHighPriority progress:nil completed:^(UIImage * _Nullable image, NSData * _Nullable data, NSError * _Nullable error, SDImageCacheType cacheType, BOOL finished, NSURL * _Nullable imageURL) {
        if (image) {
            cb(YES, image, nil);
        }
        else {
            cb(NO, nil, error);
        }
    }];
}

@end
