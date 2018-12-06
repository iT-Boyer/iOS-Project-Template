/*
 MBEmbedWebView
 MBWebView
 
 Copyright © 2018 RFUI.
 https://github.com/BB9z/iOS-Project-Template
 
 Apache License, Version 2.0
 http://www.apache.org/licenses/LICENSE-2.0
 */

#import <UIKit/UIKit.h>
#import <RFInitializing/RFInitializing.h>
#import <WebKit/WebKit.h>

@class WKWebView;

// @MBDependency:2
/**
 随内容自适应高度，一般嵌入在列表中
 */
@interface MBEmbedWebView : UIView <
    RFInitializing,
    WKNavigationDelegate
>
@property WKWebView *webView;
@end
