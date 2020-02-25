//
//  BZMParameter.h
//  Pods
//
//  Created by 杨建祥 on 2020/2/22.
//

#import <UIKit/UIKit.h>

@interface BZMParameter : NSObject
@property (class, strong, readonly) NSString *title;
@property (class, strong, readonly) NSString *model;
@property (class, strong, readonly) NSString *user;
@property (class, strong, readonly) NSString *url;
@property (class, strong, readonly) NSString *fetchLocalData;
@property (class, strong, readonly) NSString *requestRemote;
@property (class, strong, readonly) NSString *hideNavBar;
@property (class, strong, readonly) NSString *hideNavLine;
@property (class, strong, readonly) NSString *page;
@property (class, strong, readonly) NSString *pageSize;
@property (class, strong, readonly) NSString *pullRefresh;
@property (class, strong, readonly) NSString *scrollMore;
@property (class, strong, readonly) NSString *progressColor;
@property (class, strong, readonly) NSString *ocHandlers;
@property (class, strong, readonly) NSString *jsHandlers;
@property (class, strong, readonly) NSString *canCache;
@property (class, strong, readonly) NSString *useUIWebView;
@property (class, strong, readonly) NSString *animation;
@property (class, strong, readonly) NSString *message;
@property (class, strong, readonly) NSString *duration;
@property (class, strong, readonly) NSString *position;
@property (class, strong, readonly) NSString *block;

@end

