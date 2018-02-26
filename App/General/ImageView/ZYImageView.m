
#import "ZYImageView.h"
#import "MBAnalytics.h"
#import "MBApp.h"
#import "UIView+WebCacheOperation.h"
#import "debug.h"


static NSInteger ZYImageViewTimeOutCounter = 0;
extern NSSet *APIOldImageHostSet;
extern NSSet *APIImageHostSet;

@interface ZYImageView ()
@property (nonatomic, nullable) NSOperation *dowloadOperation;
@property (nonatomic, nullable) NSString *downloadingImageURL;
@property (nonatomic, nullable) NSString *completedImageURL;
@property (nonatomic, nullable) NSString *resumeImageURL;
@property (nonatomic, nullable, copy) MBGeneralCallback complation;
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
    if (![_downloadingImageURL isEqualToString:downloadingImageURL]) {
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
            RFAssert(self.window, @"只有可见时才加载图片");
            @weakify(self);
            // @TODO
            /*
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
             */
        }
    }
}

- (void)loadImageFromRemoteWithURL:(NSString *)imageURL {
    // @TODO
    /*
    RFAssert(self.hasLayoutOnce || self.width != 1000, @"只有布局过才知道需要加载多大的图片");
    NSURL *url = [ImageEntity resizedImageURLWithURLString:imageURL preferringView:self];
    self.URLForDownloadFinishCallbackVerifying = url;
    __weak RMDownloadIndicator *di = (self.downloadIndicatorEnabld && !self.image)? self.downloadIndicator : nil;

    di.hidden = YES;
    @weakify(self);
    self.dowloadOperation = (id)[SDWebImageManager.sharedManager downloadImageWithURL:url options:SDWebImageHighPriority progress:^(NSInteger receivedSize, NSInteger expectedSize) {
        _dout_float((double)receivedSize/(double)expectedSize)
        if (di && expectedSize > 0) {
            dispatch_async_on_main(^{
                di.hidden = NO;
                [di updateWithTotalBytes:expectedSize downloadedBytes:receivedSize];
            });
        }
    } completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished, NSURL *completedImageURL) {
        @strongify(self);
        if (!self) return;

        dispatch_async_on_main(^{
            if ([completedImageURL isEqual:self.URLForDownloadFinishCallbackVerifying]) {
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
            di.hidden = YES;
        });

        [self handelDownloadError:error imageURL:completedImageURL];
    }];
     */
}

- (void)handelDownloadError:(NSError *)error imageURL:(NSURL *)imageURL {
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
        || imageSize.height <= 0) {
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
