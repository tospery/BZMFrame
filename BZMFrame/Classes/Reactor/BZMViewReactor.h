//
//  BZMViewReactor.h
//  Pods
//
//  Created by 杨建祥 on 2020/2/22.
//

#import "BZMBaseReactor.h"
#import <ReactiveObjC/ReactiveObjC.h>
#import <JLRoutes/JLRRouteHandler.h>
#import "BZMProvider.h"
#import "BZMNavigator.h"

@class BZMViewReactor;

@protocol BZMViewReactorDataSource <NSObject, JLRRouteHandlerTarget>

@end

@interface BZMViewReactor : BZMBaseReactor <BZMViewReactorDataSource>
@property (nonatomic, assign) BOOL hidesNavigationBar;
@property (nonatomic, assign) BOOL hidesNavBottomLine;
@property (nonatomic, assign) BOOL shouldFetchLocalData;
@property (nonatomic, assign) BOOL shouldRequestRemoteData;
@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong, readonly) NSString *animation;
@property (nonatomic, strong, readonly) NSDictionary *parameters;
@property (nonatomic, strong) NSArray *dataSource;
@property (nonatomic, strong, readonly) BZMProvider *provider;
@property (nonatomic, strong, readonly) BZMNavigator *navigator;
@property (nonatomic, strong, readonly) RACCommand *backCommand;
@property (nonatomic, strong, readonly) RACCommand *didBackCommand;

/// 自有响应式命令/信号的初始化
- (void)didInitialize;

@end

