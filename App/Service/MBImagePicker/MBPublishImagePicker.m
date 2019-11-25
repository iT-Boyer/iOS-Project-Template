
#import "MBPublishImagePicker.h"
#import "Common.h"
#import "MBErrorCode.h"
#import "ShortCuts.h"
#import "UIKit+App.h"
#import <RFAlpha/RFImageCropperView.h>
#if __has_include("API+FileUpload.h")
#import "API+FileUpload.h"
#endif

@interface MBPublishAvatarImageCropperViewController : UIViewController
@property (weak) IBOutlet RFImageCropperView *cropperView;
@property UIImage *image;
@property BOOL shouldSkipDisappearCallback;
@end


static MBPublishImagePicker *MBPBLiveInstance = nil;

@interface MBPublishImagePicker () <
    UIImagePickerControllerDelegate,
    UINavigationControllerDelegate
>
@property (nonnull) MBGeneralCallback safeCallback;
@end


@implementation MBPublishImagePicker

+ (void)pickAvatarImageWithCropSize : (CGSize)size actionSheetTitle : (NSString *)title complation : (MBGeneralCallback)complation {
    [self pickImageWithConfiguration:^(MBPublishImagePicker *_Nonnull instance) {
        instance.cropAfterImageSelected = YES;
        instance.cropSize = size;
    } complation:complation];
}

+ (void)pickImageWithConfiguration:(NS_NOESCAPE void (^)(MBPublishImagePicker *_Nonnull))configBlock complation:(MBGeneralCallback)complation {
    MBGeneralCallback safeCallback = MBSafeCallback(complation);
    if (MBPBLiveInstance) {
        safeCallback(NO, nil, [NSError errorWithDomain:MBPublishImagePicker.errorDomain code:MBErrorOperationRepeat localizedDescription:@"已经在选择图片"]);
        return;
    }

    MBPublishImagePicker *instance = [MBPublishImagePicker new];
    if (configBlock) {
        configBlock(instance);
    }
    if (instance.cropAfterImageSelected) {
        CGSize size = instance.cropSize;
        NSParameterAssert(size.width > 10 && size.height > 10);
    }
    if (instance.shouldReturnRawPickerInfoInsteadOfImageObject) {
        RFAssert(!instance.autoUpload && !instance.cropAfterImageSelected, @"配置冲突");
    }
    instance.safeCallback = safeCallback;
    MBPBLiveInstance = instance;
    [instance presentSystemImagePickers];
}

#pragma mark - 响应选图

- (void)presentSystemImagePickers {
    if (self.onlyCameraPicker) {
        [self presentImagePickerViewContorllerWithSourceType:UIImagePickerControllerSourceTypeCamera];
        return;
    }
    if (self.onlyLibraryPicker) {
        [self presentImagePickerViewContorllerWithSourceType:UIImagePickerControllerSourceTypePhotoLibrary];
        return;
    }

    // 弹框选择数据源
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:self.selectImagePickerSourceTitle ?: @"选择图像" message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary]) {
        [alert addAction:[UIAlertAction actionWithTitle:@"从相册选取" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [self presentImagePickerViewContorllerWithSourceType:UIImagePickerControllerSourceTypePhotoLibrary];
        }]];
    }
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        [alert addAction:[UIAlertAction actionWithTitle:@"相机" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [self presentImagePickerViewContorllerWithSourceType:UIImagePickerControllerSourceTypeCamera];
        }]];
    }
    [alert addAction:[UIAlertAction actionWithTitle:NSLocalizedString(@"Cancel", @"取消") style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        MBPBLiveInstance.safeCallback(NO, nil, nil);
        MBPBLiveInstance = nil;
    }]];
    UIPopoverPresentationController *ppc = alert.popoverPresentationController;
    if (ppc) {
        ppc.barButtonItem = self.popoverPresentationBarButtonItem;
        ppc.sourceRect = self.popoverPresentationSourceRect;
        ppc.sourceView = self.popoverPresentationSourceView;
        if (self.popoverConfiguration) {
            self.popoverConfiguration(ppc);
        }
    }
    [AppNavigationController() presentViewController:alert animated:YES completion:nil];
}

- (void)presentImagePickerViewContorllerWithSourceType:(UIImagePickerControllerSourceType)sourceType {
    UIImagePickerController *pik = [[UIImagePickerController alloc] init];
    pik.sourceType = sourceType;
    pik.delegate = self;
    [AppNavigationController() presentViewController:pik animated:YES completion:nil];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *, id> *)info {
    if (self.shouldReturnRawPickerInfoInsteadOfImageObject) {
        MBPBLiveInstance.safeCallback(YES, info, nil);
        MBPBLiveInstance = nil;
        [picker dismissViewControllerAnimated:YES completion:nil];
        return;
    }

    UIImage *orgImage = info[UIImagePickerControllerOriginalImage];
    if (!orgImage) {
        MBPBLiveInstance.safeCallback(NO, nil, [NSError errorWithDomain:MBPublishImagePicker.errorDomain code:MBErrorDataNotAvailable localizedDescription:@"图片选取失败"]);
        MBPBLiveInstance = nil;
        [picker dismissViewControllerAnimated:YES completion:nil];
        return;
    }

    if (self.cropAfterImageSelected) {
        MBPublishAvatarImageCropperViewController *vc = [MBPublishAvatarImageCropperViewController newFromStoryboard];
        vc.image = orgImage;
        [AppNavigationController() pushViewController:vc animated:NO];
    }
    else {
        if (self.autoUpload) {
            [self uploadImage:orgImage];
        }
        else {
            MBPBLiveInstance.safeCallback(YES, orgImage, nil);
            MBPBLiveInstance = nil;
        }
    }
    [picker dismissViewControllerAnimated:YES completion:nil];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [picker dismissViewControllerAnimated:YES completion:nil];
    MBPBLiveInstance.safeCallback(NO, nil, nil);
    MBPBLiveInstance = nil;
}

#pragma mark - 选完图片后的操作

- (void)cropFinishedWithCroppedImage:(UIImage *)image cancel:(BOOL)cancel {
    if (cancel || !self.autoUpload) {
        self.safeCallback(!cancel, image, nil);
        MBPBLiveInstance = nil;
        return;
    }
    if (!image) {
        self.safeCallback(NO, nil, [NSError errorWithDomain:MBPublishImagePicker.errorDomain code:MBErrorDataNotAvailable localizedDescription:@"裁切图像获取失败"]);
        MBPBLiveInstance = nil;
        return;
    }
    [self uploadImage:image];
}

- (void)uploadImage:(UIImage *)image {
    @autoreleasepool {
        if (!CGSizeEqualToSize(self.uploadImageSizeLimit, CGSizeZero)) {
            image = [image thumbnailImageWithMaxSize:self.uploadImageSizeLimit];
        }
        NSData *imageData = UIImageJPEGRepresentation(image, .6);
        if (!imageData) {
            self.safeCallback(NO, nil, [NSError errorWithDomain:MBPublishImagePicker.errorDomain code:MBErrorDataNotAvailable localizedDescription:@"上传图片无法获取"]);
            MBPBLiveInstance = nil;
            return;
        }
        [AppHUD() showActivityIndicatorWithIdentifier:@"imageUpload" groupIdentifier:self.className model:YES message:self.loadingText];
        #if __has_include("API+FileUpload.h")
        [AppAPI() uploadImageWithData:imageData callback:^(BOOL success, NSURL *imageURL, NSError * error) {
            [AppHUD() hideWithIdentifier:@"imageUpload"];
            self.safeCallback(success, imageURL, error);
            MBPBLiveInstance = nil;
        }];
        #else
        RFAssert(false, @"图片上传组件未导入");
        #endif
    }
}

+ (NSString *)errorDomain {
    return NSStringFromClass(self);
}

@end


#pragma mark -


@implementation MBPublishAvatarImageCropperViewController
//MBPrefersMoveInTransitioningStyle

+ (NSString *)storyboardName {
    return @"Main";
}

- (void)viewDidLoad {
    [super viewDidLoad];
    NSParameterAssert(self.image);
    NSParameterAssert(MBPBLiveInstance);

    RFImageCropperView *cv = [[RFImageCropperView alloc] initWithFrame:self.view.bounds];
    cv.backgroundColor = UIColor.darkGrayColor;
    cv.autoresizingMask = UIViewAutoresizingFlexibleSize;
    [self.view insertSubview:cv atIndex:0];

    cv.frameView.borderColor = [UIColor colorWithRGBHex:0xFFC21C];
    cv.sourceImage = self.image;
    cv.cropSize = MBPBLiveInstance.cropSize;

    if (cv.cropSize.width > self.view.width - 20) {
        double scale = (self.view.width - 20) / cv.cropSize.width;
        cv.transform = CGAffineTransformMakeScale(scale, scale);
    }
    cv.frame = self.view.bounds;
    self.cropperView = cv;
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    if (self.shouldSkipDisappearCallback) return;
    if (MBPBLiveInstance) {
        [MBPBLiveInstance cropFinishedWithCroppedImage:nil cancel:YES];
    }
}

- (IBAction)onCancel:(id)sender {
    self.shouldSkipDisappearCallback = YES;
    [AppNavigationController() popViewControllerAnimated:YES];
    [MBPBLiveInstance cropFinishedWithCroppedImage:nil cancel:YES];
}

- (IBAction)onPick:(id)sender {
    self.shouldSkipDisappearCallback = YES;
    [AppNavigationController() popViewControllerAnimated:YES];
    [MBPBLiveInstance cropFinishedWithCroppedImage:[self.cropperView croppedImage] cancel:NO];
}

@end