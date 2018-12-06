
#import "MBEmbedWebView.h"
#import <RFAlpha/RFKVOWrapper.h>
#import <RFKit/NSURL+RFKit.h>
#import <RFKit/UITableView+RFKit.h>
#import <RFKit/UIView+RFKit.h>
#import <RFKit/UIView+RFAnimate.h>
@import AVKit;
@import SafariServices;

@interface MBEmbedWebView ()
@property (nonatomic) BOOL autoUpdateEnabled;
@property id _MBWebView_contentSizeObserver;
@property (nonatomic) CGFloat _MBEmbedWebView_lastContentHeight;
@end

@implementation MBEmbedWebView
RFInitializingRootForUIView

- (void)onInit {
    __MBEmbedWebView_lastContentHeight = UIViewNoIntrinsicMetric;
    WKWebViewConfiguration *conf = [WKWebViewConfiguration.alloc init];
    WKWebView *wb = [WKWebView.alloc initWithFrame:self.bounds configuration:conf];
    wb.autoresizingMask = UIViewAutoresizingFlexibleSize;
    [self addSubview:wb];
    self.webView = wb;
    self.webView.navigationDelegate = self;
}

- (void)afterInit {
}

- (void)dealloc {
    self.autoUpdateEnabled = NO;
}

- (CGSize)intrinsicContentSize {
    CGFloat height = self._MBEmbedWebView_lastContentHeight;
    if (height <= 0) {
        height = self.webView.scrollView.contentSize.height;
    }
    return CGSizeMake(self.width, height);
}

- (void)updateSize {
    [self.webView evaluateJavaScript:@"document.documentElement.scrollHeight" completionHandler:^(NSNumber *height, NSError * _Nullable error) {
        if (![height isKindOfClass:NSNumber.class]) return;
        self._MBEmbedWebView_lastContentHeight = height.doubleValue;
    }];
}

- (void)set_MBEmbedWebView_lastContentHeight:(CGFloat)height {
    if (__MBEmbedWebView_lastContentHeight == height) return;
    __MBEmbedWebView_lastContentHeight = height;
    [self invalidateIntrinsicContentSize];
}

- (void)willMoveToWindow:(UIWindow *)newWindow {
    [super willMoveToWindow:newWindow];
    self.autoUpdateEnabled = !!newWindow;
}

/*
 关于高度更新
 
 - 只使用 webView scrollView 的 contentSize 是不行的，在 10.3 之后，旋转屏幕底部会有空白
 - 用 js 取 document.height 不行，拿不到
 - KVO 监听 contentSize，变化后通过 document.body.scrollHeight 获取高度会循环变得越来越大
 - document.body.scrollHeight 在旋转后还是更大的那个
 - KVO 监听 contentSize，在跳转到其他页面可能会不断触发
 - KVO 监听 contentSize，滚动中也会不断触发
 - HTML 中的 <meta name="viewport" content="width=device-width, initial-scale=1"> 可能是必须的
 */
- (void)setAutoUpdateEnabled:(BOOL)autoUpdateEnabled {
    if (_autoUpdateEnabled == autoUpdateEnabled) return;
    if (_autoUpdateEnabled) {
        [self.webView.scrollView RFRemoveObserverWithIdentifier:self._MBWebView_contentSizeObserver];
    }
    _autoUpdateEnabled = autoUpdateEnabled;
    if (autoUpdateEnabled) {
        self._MBWebView_contentSizeObserver = [self.webView.scrollView RFAddObserver:self forKeyPath:@keypath(self.webView.scrollView, contentSize) options:(NSKeyValueObservingOptionNew|NSKeyValueObservingOptionOld) queue:nil block:^(MBEmbedWebView *observer, NSDictionary *change) {
            _douto(change)
            if ([change[NSKeyValueChangeOldKey] isEqual:change[NSKeyValueChangeNewKey]]) return;
            [observer updateSize];
        }];
    }
}

- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation {
    [self updateSize];
}

- (void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler {
    NSURL *requestURL = navigationAction.request.URL;
    if ([requestURL.scheme isEqualToString:@"video"]) {
        decisionHandler(WKNavigationActionPolicyCancel);
        NSString *urlString = requestURL.queryDictionary[@"url"];
        NSURL *url = nil;
        if (urlString) {
            url = [NSURL.alloc initWithString:urlString];
        }
        if (!url) {
            NSString *file = requestURL.queryDictionary[@"file"];
            if (!file) return;
            url = [NSURL.alloc initWithString:file relativeToURL:webView.URL];
        }
        if (!url) return;
        AVPlayerViewController *vc = [AVPlayerViewController.alloc init];
        vc.player = [AVPlayer.alloc initWithURL:url];
        [vc.player play];
        [self.viewController.navigationController pushViewController:vc animated:YES];
        return;
    }
    if (navigationAction.navigationType == WKNavigationTypeLinkActivated) {
        decisionHandler(WKNavigationActionPolicyCancel);
        SFSafariViewController *vc = [SFSafariViewController.alloc initWithURL:requestURL];
        UINavigationController *nav = self.viewController.navigationController;
        if (@available(iOS 10.0, *)) {
            vc.preferredBarTintColor = nav.navigationBar.barTintColor;
            vc.preferredControlTintColor = nav.navigationBar.tintColor;
        }
        if (@available(iOS 11.0, *)) {
            vc.dismissButtonStyle = SFSafariViewControllerDismissButtonStyleClose;
        }
        [self.viewController.navigationController presentViewController:vc animated:YES completion:nil];
        return;
    }
    decisionHandler(WKNavigationActionPolicyAllow);
}

@end
