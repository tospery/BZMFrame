//
//  BZMWebViewController.h
//  Pods
//
//  Created by 杨建祥 on 2020/1/8.
//

#import "BZMScrollViewController.h"
#import <WebKit/WebKit.h>
#import <WebViewJavascriptBridge/WebViewJavascriptBridge.h>
#import "BZMWebViewModel.h"

@interface BZMWebViewController : BZMScrollViewController <WKNavigationDelegate, WKUIDelegate>
@property (nonatomic, strong, readonly) BZMWebViewModel *viewModel;
@property (nonatomic, strong, readonly) WKWebView *webView;
@property (nonatomic, strong, readonly) WebViewJavascriptBridge *bridge;

@end

