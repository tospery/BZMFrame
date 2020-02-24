//
//  BZMWebViewController.h
//  Pods
//
//  Created by 杨建祥 on 2020/2/23.
//

#import "BZMScrollViewController.h"
#import <WebKit/WebKit.h>
#import <WebViewJavascriptBridge/WebViewJavascriptBridge.h>

@interface BZMWebViewController : BZMScrollViewController <WKNavigationDelegate, WKUIDelegate>
@property (nonatomic, strong, readonly) WKWebView *webView;
@property (nonatomic, strong, readonly) WebViewJavascriptBridge *bridge;

@end

