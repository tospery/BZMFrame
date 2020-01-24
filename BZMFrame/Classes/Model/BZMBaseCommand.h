//
//  BZMBaseCommand.h
//  Pods
//
//  Created by 杨建祥 on 2020/1/17.
//

#import <UIKit/UIKit.h>
#import <WebViewJavascriptBridge/WebViewJavascriptBridge.h>
#import "BZMWebViewModel.h"

@interface BZMBaseCommand : NSObject
@property (nonatomic, strong, readonly) BZMWebViewModel *viewModel;

- (instancetype)initWithViewModel:(BZMWebViewModel *)viewModel;

- (void)handle:(id)data responseCallback:(WVJBResponseCallback)responseCallback;

@end

