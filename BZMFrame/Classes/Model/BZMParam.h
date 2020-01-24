//
//  BZMParam.h
//  Pods
//
//  Created by 杨建祥 on 2020/1/21.
//

#import <UIKit/UIKit.h>

@interface BZMParam : NSObject
@property (class, strong, readonly) NSString *title;
@property (class, strong, readonly) NSString *model;
@property (class, strong, readonly) NSString *url;
@property (class, strong, readonly) NSString *fetchLocal;
@property (class, strong, readonly) NSString *requestRemote;
@property (class, strong, readonly) NSString *hideNavBar;
@property (class, strong, readonly) NSString *hideNavBottomLine;
@property (class, strong, readonly) NSString *page;
@property (class, strong, readonly) NSString *pageSize;
@property (class, strong, readonly) NSString *pullRefresh;
@property (class, strong, readonly) NSString *scrollMore;
@property (class, strong, readonly) NSString *progressColor;
@property (class, strong, readonly) NSString *nativeHandlers;
@property (class, strong, readonly) NSString *jsHandlers;
@property (class, strong, readonly) NSString *canCache;
@property (class, strong, readonly) NSString *useUIWebView;

@end

