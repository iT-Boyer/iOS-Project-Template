
#import "MBTabControl.h"
#import "MBTabScrollView.h"
#import "UIView+RFAnimate.h"
#import "RFKVOWrapper.h"

@interface MBTabControl ()
@property (weak, nonatomic) id tabScrollViewPageObserver;
@end

@implementation MBTabControl

- (void)onInit {
    [super onInit];
    _indicatingImageBottomHeight = 2;
    _indicatingImageExpand = 2;
}

- (void)updateIndicatingImage {
    CGFloat bottom = self.indicatingImageBottomHeight;
    CGFloat bottomSpacing = self.indicatorBottomSpacing;

    UIGraphicsBeginImageContextWithOptions(CGSizeMake(1, bottom + bottomSpacing + 2), NO, 0);
    UIBezierPath* rectanglePath = [UIBezierPath bezierPathWithRect:CGRectMake(0, 2, 1, bottom)];
    [self.tintColor setFill];
    [rectanglePath fill];

    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();

    self.indicatingImageView.image = [image resizableImageWithCapInsets:UIEdgeInsetsMake(1, 0, bottom + bottomSpacing, 0) resizingMode:UIImageResizingModeStretch];
}

- (void)awakeFromNib {
    [super awakeFromNib];

    if (!self.indicatingImageView && self.indicatorEnabled) {
        self.indicatingImageView = [[UIImageView alloc] initWithFrame:self.bounds];
        self.indicatingImageView.autoresizingMask = UIViewAutoresizingFlexibleRightMargin|UIViewAutoresizingFlexibleHeight;
        [self updateIndicatingImage];
        [self addSubview:self.indicatingImageView];
    }

    if (!self.controls) {
        NSMutableArray *controls = [NSMutableArray arrayWithCapacity:self.subviews.count];
        __block NSInteger selectIndex = NSNotFound;
        __block UIControl *prevSelectedControl = nil;
        [self.subviews enumerateObjectsUsingBlock:^(UIControl *v, NSUInteger idx, BOOL *stop) {
            if ([v isKindOfClass:[UIControl class]]) {
                [controls addObject:v];

                if (v.selected) {
                    selectIndex = idx;

                    if (prevSelectedControl) {
                        prevSelectedControl.selected = NO;
                    }
                    prevSelectedControl = v;
                }
            }
        }];

        self.controls = controls;
        if (selectIndex != NSNotFound) {
            self.selectIndex = selectIndex;
        }
    }

    self.tabScrollView.page = self.selectIndex;
}

- (void)setSelectedControl:(UIControl *)selectedControl {
    [super setSelectedControl:selectedControl];

    if (self.pageScrollDuration) {
        [UIView animateWithDuration:self.pageScrollDuration animations:^{
            self.tabScrollView.page = self.selectIndex;
        }];
    }
    else {
        self.tabScrollView.page = self.selectIndex;
    }
    if (self.window) {
        [UIView animateWithDuration:.3 delay:0 usingSpringWithDamping:0.5 initialSpringVelocity:1 options:UIViewAnimationOptionBeginFromCurrentState|UIViewAnimationOptionCurveEaseOut animations:^{
            [self updateIndicatingImageViewFrame];
        } completion:nil];
    }
    else {
        [self updateIndicatingImageViewFrame];
    }
}

- (void)layoutSubviews {
    [super layoutSubviews];
    [self updateIndicatingImageViewFrame];
}

- (void)updateIndicatingImageViewFrame {
    if (!self.indicatorEnabled) return;
    UIButton *button = (id)self.selectedControl;
    if (!button) {
        self.indicatingImageView.alpha = 0;
        return;
    }
    else if (![button isKindOfClass:[UIButton class]]) {
        return;
    }
    self.indicatingImageView.alpha = 1;

    UIImageView *indicator = self.indicatingImageView;
    CGFloat width = CGRectGetWidth(button.titleLabel.frame);
    if (button.titleLabel.text.length && width == 0) {
        [button.titleLabel sizeToFit];
    }
    CGFloat indicatorWidth;
    if (self.indicatingImageWidthSameAsButton) {
        indicatorWidth = button.width + self.indicatingImageExpand;
    }
    else {
        indicatorWidth = button.titleLabel.width + button.imageView.width + button.titleEdgeInsets.left + button.imageEdgeInsets.right + self.indicatingImageExpand * 2;
    }
    
    if (self.indicatingImageWidth) {
        indicatorWidth = self.indicatingImageWidth;
    }
    
    indicator.width = indicatorWidth;
    CGPoint center = indicator.center;
    center.x = button.center.x;
    indicator.center = center;
}

- (void)setTabScrollView:(MBTabScrollView *)tabScrollView {
    if (_tabScrollView != tabScrollView) {
        if (_tabScrollView && self.tabScrollViewPageObserver) {
            [_tabScrollView RFRemoveObserverWithIdentifier:self.tabScrollViewPageObserver];
        }

        if (tabScrollView) {
            @weakify(tabScrollView);
            self.tabScrollViewPageObserver = [tabScrollView RFAddObserver:self forKeyPath:@keypath(tabScrollView, page) options:(NSKeyValueObservingOptions)(NSKeyValueObservingOptionNew|NSKeyValueObservingOptionInitial) queue:nil block:^(MBTabControl *observer, NSDictionary *change) {
                @strongify(tabScrollView);
                if (tabScrollView.contentSize.width > 0) {
                    // 否则 view 都没初始化，设置是错的
                    if (observer.selectIndex != tabScrollView.page) {
                        observer.selectIndex = tabScrollView.page;
                    }
                }
            }];
        }
        _tabScrollView = tabScrollView;
    }
}

@end
