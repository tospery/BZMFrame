//
//  BZMWebViewController.m
//  Pods
//
//  Created by 杨建祥 on 2020/1/8.
//

#import "BZMWebViewController.h"
#import <ReactiveObjC/ReactiveObjC.h>
#import <ReactiveObjC/NSObject+RACKVOWrapper.h>
#import <Toast/UIView+Toast.h>
#import "BZMConstant.h"
#import "BZMFunction.h"
#import "BZMWebViewModel.h"
#import "BZMWebProgressView.h"
#import "NSString+BZMFrame.h"

#define kBZMWebEstimatedProgress         (@"estimatedProgress")

@interface BZMWebViewController ()
@property (nonatomic, strong, readwrite) BZMWebViewModel *viewModel;
@property (nonatomic, strong, readwrite) WKWebView *webView;
@property (nonatomic, strong) BZMWebProgressView *progressView;
@property (nonatomic, strong, readwrite) WebViewJavascriptBridge *bridge;

@end

@implementation BZMWebViewController
@dynamic viewModel;

#pragma mark - Init
- (void)dealloc {
    _webView.navigationDelegate = nil;
    _webView.UIDelegate = nil;
    _webView = nil;
}

#pragma mark - View
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.view addSubview:self.webView];
    self.webView.frame = CGRectMake(0, self.contentTop, self.view.qmui_width, self.view.qmui_height - self.contentTop - self.contentBottom);
    
    [self.view addSubview:self.progressView];
    
    @weakify(self)
    for (NSString *handler in self.viewModel.ocHandlers) {
        if (![handler isKindOfClass:NSString.class]) {
            continue;
        }
        [self.bridge registerHandler:handler handler:^(id data, WVJBResponseCallback responseCallback) {
            @strongify(self)
            NSString *method = BZMStrWithFmt(@"%@:callback:", handler.bzm_camelFromUnderline);
            SEL selector = NSSelectorFromString(method);
            if ([self.viewModel respondsToSelector:selector]) {
                ((id(*)(id, SEL, id, WVJBResponseCallback))[self.viewModel methodForSelector:selector])(self.viewModel, selector, data, responseCallback);
            }else {
                BZMLogWarn(@"Web找不到oc handler: %@", method);
                [self.view makeToast:BZMStrWithFmt(@"缺少%@方法", method)];
            }
        }];
    }
}

#pragma mark - Property
- (WKWebView *)webView {
    if (!_webView) {
        WKWebViewConfiguration *configuration = [[WKWebViewConfiguration alloc] init];
        WKWebView *webView = [[WKWebView alloc] initWithFrame:CGRectZero configuration:configuration];
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
- (void)bindViewModel {
    [super bindViewModel];
    
    @weakify(self)
    [self.webView rac_observeKeyPath:kBZMWebEstimatedProgress options:NSKeyValueObservingOptionNew observer:nil block:^(id value, NSDictionary *change, BOOL causedByDealloc, BOOL affectedOnlyLastComponent) {
        @strongify(self)
        if ([value isKindOfClass:NSNumber.class]) {
            [self updateProgress:[(NSNumber *)value floatValue]];
        }
    }];
}

- (void)reloadData {
    [super reloadData];
}

- (void)triggerLoad {
    NSURLRequest *request = [NSURLRequest requestWithURL:self.viewModel.url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:10];
    [self.webView loadRequest:request];
}

- (void)updateProgress:(CGFloat)progress {
    [self.progressView setProgress:progress animated:YES];
    if (self.viewModel.title.length == 0) {
        @weakify(self)
        [self.webView evaluateJavaScript:@"document.title" completionHandler:^(NSString *title, NSError *error) {
            @strongify(self)
            self.viewModel.title = title;
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
