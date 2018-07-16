
#import "ZYImageView.h"
#import "ImageEntity.h"
#import "MBApp.h"
#import "debug.h"
#import <SDWebImageManager.h>
#import <UIView+WebCacheOperation.h>


@interface ZYImageView ()
@property NSOperation *dowloadOperation;
@property (nonatomic) NSString *downloadingImageURL;
@property NSString *completedImageURL;
@property MBGeneralCallback complation;
@property NSURL *URLForDownloadFinishCallbackVerifying;
@property BOOL hasLayoutOnce;
@end

@implementation ZYImageView
RFInitializingRootForUIView

- (void)onInit {
    self.clipsToBounds = YES;
    self.contentMode = UIViewContentModeScaleAspectFill;
}

- (void)afterInit {
}

- (void)awakeFromNib {
    [super awakeFromNib];
    if (self.image) {
        self.placeholderImage = self.image;
    }
    if (self.placeholderImage) {
        self.image = self.placeholderImage;
    }
}

- (void)layoutSubviews {
    [super layoutSubviews];
    if (!self.hasLayoutOnce) {
        self.hasLayoutOnce = YES;
    }
}

- (void)didMoveToWindow {
    [super didMoveToWindow];
    if (self.disableDownloadPauseWhenRemoveFromWindow) return;
    if (self.window) {
        if (self.completedImageURL != self.imageURL) {
            self.downloadingImageURL = self.imageURL;
        }
    }
    else {
        self.downloadingImageURL = nil;
    }
}

- (void)fetchImageWithImageURL:(NSString *)imageURL complete:(MBGeneralCallback)complation {
    // 回调覆盖什么的先简单处理
    self.complation = complation;
    self.imageURL = imageURL;
}

- (void)setImageURL:(NSString *)imageURL {
    if (![_imageURL isEqualToString:imageURL]) {
        if (_imageURL) {
            self.completedImageURL = nil;
        }
        _imageURL = imageURL;
        self.image = self.placeholderImage;
        if (imageURL) {
            dispatch_block_t startLoadingBlock = ^(){
                if (self.window) {
                    self.downloadingImageURL = imageURL;
                };
            };

            if (self.hasLayoutOnce) {
                startLoadingBlock();
            }
            else {
                dispatch_after_seconds(0, startLoadingBlock);
            }
        }
        if (self.downloadingImageURL != imageURL) {
            self.downloadingImageURL = nil;
        }
    }
}

- (void)setDownloadingImageURL:(NSString *)downloadingImageURL {
    if ([_downloadingImageURL isEqualToString:downloadingImageURL]) return;

    if (_downloadingImageURL) {
        if (downloadingImageURL == self.imageURL) {
            // 新值和 imageURL 相同，意味着传入的是新图片，应该通知旧的图片已取消
            if (self.complation) {
                self.complation(NO, nil, nil);
                self.complation = nil;
            }
        }
        [self.dowloadOperation cancel];
    }
    _downloadingImageURL = downloadingImageURL;
    if (downloadingImageURL) {
        @weakify(self);
        [ImageEntity fetchCahcedImageWithImagePath:downloadingImageURL preferredPixelWidth:[ImageEntity pixelWidthOfView:self] complation:^(UIImage * _Nullable cachedImage) {
            @strongify(self);
            if (!self) return;
            if (![downloadingImageURL isEqualToString:self.imageURL]) return;
            
            if (cachedImage) {
                self.image = cachedImage;
                if (self.complation) {
                    self.complation(YES, cachedImage, nil);
                }
            }
            [self loadImageFromRemoteWithURL:downloadingImageURL];
        }];
    }
}

- (void)loadImageFromRemoteWithURL:(NSString *)imageURL {
    RFAssert(self.hasLayoutOnce || self.width != 1000, @"只有布局过才知道需要加载多大的图片");
    NSURL *url = [ImageEntity resizedImageURLWithURLString:imageURL preferringView:self];
    self.URLForDownloadFinishCallbackVerifying = url;
    
    @weakify(self);
    self.dowloadOperation = (id)[SDWebImageManager.sharedManager loadImageWithURL:url options:SDWebImageHighPriority progress:nil completed:^(UIImage * _Nullable image, NSData * _Nullable data, NSError * _Nullable error, SDImageCacheType cacheType, BOOL finished, NSURL * _Nullable imageURL) {
        @strongify(self);
        if (!self) return;
        
        dispatch_async_on_main(^{
            if ([imageURL isEqual:self.URLForDownloadFinishCallbackVerifying]) {
                self.URLForDownloadFinishCallbackVerifying = nil;
                self.completedImageURL = self.imageURL;
                if (image) {
                    self.image = image;
                }
                else if (self.failureImage) {
                    self.image = self.failureImage;
                }
                else if (self.placeholderImage) {
                    self.image = self.placeholderImage;
                }
            }
            
            if (self.complation) {
                self.complation(finished, image, error);
                self.complation = nil;
            }
        });
    }];
}

- (void)setImageWithURLString:(NSString *)path placeholderImage:(UIImage *)placeholder {
    NSAssert(false, @"请使用 ZYImageView 的方法");
}

#pragma mark -

- (void)setBounds:(CGRect)bounds {
    if (self.intrinsicContentSizeFixEnabled) {
        if (CGRectGetWidth(self.bounds) != CGRectGetWidth(bounds)) {
            [self invalidateIntrinsicContentSize];
        }
    }
    [super setBounds:bounds];
}

- (CGSize)intrinsicContentSize {
    CGSize osize = [super intrinsicContentSize];
    if (!self.intrinsicContentSizeFixEnabled) {
        return osize;
    }

    CGSize imageSize = self.image.size;
    CGFloat width = self.bounds.size.width;
    if (imageSize.width <= 0
        || imageSize.height <= 0
        || width == 0) {
        return osize;
    }
    switch (self.contentMode) {
        case UIViewContentModeScaleAspectFit: {
            if (width > imageSize.width) {
                return CGSizeMake(width, imageSize.height);
            }
            // Else continue as fill
        }
        case UIViewContentModeScaleToFill:
        case UIViewContentModeScaleAspectFill: {
            return CGSizeMake(width, imageSize.height/imageSize.width*width);
        }

        default:
            return CGSizeMake(width, imageSize.height);
    }
}

@end
