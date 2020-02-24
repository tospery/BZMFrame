//
//  BZMWebViewController.m
//  Pods
//
//  Created by 杨建祥 on 2020/2/23.
//

#import "BZMWebViewController.h"
#import <ReactiveObjC/ReactiveObjC.h>
#import <ReactiveObjC/NSObject+RACKVOWrapper.h>
#import <Toast/UIView+Toast.h>
#import <DKNightVersion/DKNightVersion.h>
#import "BZMConstant.h"
#import "BZMFunction.h"
#import "BZMParameter.h"
#import "BZMWebViewReactor.h"
#import "BZMWebProgressView.h"
#import "NSString+BZMFrame.h"
#import "NSURL+BZMFrame.h"

#define kBZMWebEstimatedProgress         (@"estimatedProgress")

@interface BZMWebViewController ()
@property (nonatomic, strong) BZMWebProgressView *progressView;
@property (nonatomic, strong, readwrite) WKWebView *webView;
@property (nonatomic, strong, readwrite) WebViewJavascriptBridge *bridge;
@property (nonatomic, strong, readwrite) BZMWebViewReactor *reactor;

@end

@implementation BZMWebViewController
@dynamic reactor;

#pragma mark - Init
- (instancetype)initWithReactor:(BZMViewReactor *)reactor {
    if (self = [super initWithReactor:reactor]) {
    }
    return self;
}

- (void)dealloc {
    _webView.navigationDelegate = nil;
    _webView.UIDelegate = nil;
    _webView = nil;
}

#pragma mark - View
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.view addSubview:self.webView];
    [self.view addSubview:self.progressView];
    
    @weakify(self)
    for (NSString *handler in self.reactor.ocHandlers) {
        if (![handler isKindOfClass:NSString.class]) {
            continue;
        }
        [self.bridge registerHandler:handler handler:^(id data, WVJBResponseCallback responseCallback) {
            @strongify(self)
            NSString *method = BZMStrWithFmt(@"%@:callback:", handler.bzm_camelFromUnderline);
            SEL selector = NSSelectorFromString(method);
            if ([self.reactor respondsToSelector:selector]) {
                ((id(*)(id, SEL, id, WVJBResponseCallback))[self.reactor methodForSelector:selector])(self.reactor, selector, data, responseCallback);
            }else {
                BZMLogWarn(@"Web找不到oc handler: %@", method);
                [self.navigator routeURL:BZMURLWithPattern(kBZMPatternToast) withParameters:@{
                    BZMParameter.message: BZMStrWithFmt(@"缺少%@方法", method)
                }];
            }
        }];
    }
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    // self.webView.frame = self.contentFrame;
}

#pragma mark - Property
- (WKWebView *)webView {
    if (!_webView) {
        WKWebViewConfiguration *configuration = [[WKWebViewConfiguration alloc] init];
        WKWebView *webView = [[WKWebView alloc] initWithFrame:self.contentFrame configuration:configuration];
        webView.dk_backgroundColorPicker = DKColorPickerWithKey(BG);
        webView.navigationDelegate = self;
        webView.UIDelegate = self;
        _webView = webView;
    }
    return _webView;
}

- (BZMWebProgressView *)progressView {
    if (!_progressView) {
        BZMWebProgressView *progressView = [[BZMWebProgressView alloc] initWithFrame:CGRectMake(0, self.contentTop, self.view.qmui_width, 1.5f)];
        _progressView = progressView;
    }
    return _progressView;
}

- (WebViewJavascriptBridge *)bridge {
    if (!_bridge) {
        _bridge = [WebViewJavascriptBridge bridgeForWebView:self.webView];
        [_bridge setWebViewDelegate:self];
    }
    return _bridge;
}

#pragma mark - Method
- (void)bind:(BZMBaseReactor *)reactor {
    [super bind:reactor];
    
    @weakify(self)
    [self.webView rac_observeKeyPath:kBZMWebEstimatedProgress options:NSKeyValueObservingOptionNew observer:nil block:^(id value, NSDictionary *change, BOOL causedByDealloc, BOOL affectedOnlyLastComponent) {
        @strongify(self)
        if ([value isKindOfClass:NSNumber.class]) {
            [self updateProgress:[(NSNumber *)value floatValue]];
        }
    }];
}

//- (void)reloadData {
//    [super reloadData];
//}

- (void)triggerLoad {
    NSURLRequest *request = [NSURLRequest requestWithURL:self.reactor.url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:10];
    [self.webView loadRequest:request];
}

- (void)updateProgress:(CGFloat)progress {
    [self.progressView setProgress:progress animated:YES];
    if (self.reactor.title.length == 0) {
        @weakify(self)
        [self.webView evaluateJavaScript:@"document.title" completionHandler:^(NSString *title, NSError *error) {
            @strongify(self)
            self.reactor.title = title;
        }];
    }
}

#pragma mark - Delegate
#pragma mark WKNavigationDelegate
- (void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler {
    decisionHandler(WKNavigationActionPolicyAllow);
}

- (void)webView:(WKWebView *)webView didStartProvisionalNavigation:(WKNavigation *)navigation {
    [self.progressView setProgress:0 animated:NO];
}

- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation {
    // [self didFinish:nil];
}

- (void)webView:(WKWebView *)webView didFailNavigation:(WKNavigation *)navigation withError:(NSError *)error {
    // [self didFinish:error];
}

- (void)webView:(WKWebView *)webView didFailProvisionalNavigation:(WKNavigation *)navigation withError:(NSError *)error {
    // [self didFinish:error];
}

#pragma mark WKUIDelegate
- (void)webView:(WKWebView *)webView runJavaScriptAlertPanelWithMessage:(NSString *)message initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(void))completionHandler {
//    [BZMPrompt showAlertWithTitle:nil message:message cancelText:@"确定" submitText:nil handler:^(NSString *text) {
//        completionHandler();
//    }];
}

- (void)webView:(WKWebView *)webView runJavaScriptConfirmPanelWithMessage:(NSString *)message initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(BOOL result))completionHandler {
    // YJX_TODO
//    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil message:message delegate:nil cancelButtonTitle:kStringCancel otherButtonTitles:kStringOK, nil];
//    [alertView.rac_buttonClickedSignal subscribeNext:^(NSNumber *index) {
//        completionHandler(index.integerValue == 1);
//    }];
//    [alertView show];
}

- (void)webView:(WKWebView *)webView runJavaScriptTextInputPanelWithPrompt:(NSString *)prompt defaultText:(NSString *)defaultText initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(NSString *result))completionHandler {
//    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil message:prompt delegate:nil cancelButtonTitle:kStringCancel otherButtonTitles:kStringOK, nil];
//    alertView.alertViewStyle = UIAlertViewStylePlainTextInput;
//    UITextField *textField = [alertView textFieldAtIndex:0];
//    textField.placeholder = defaultText;
//    [alertView.rac_buttonClickedSignal subscribeNext:^(NSNumber *index) {
//        completionHandler(index.integerValue == 1 ? textField.text : nil);
//    }];
//    [alertView show];
}

#pragma mark - Class

@end
