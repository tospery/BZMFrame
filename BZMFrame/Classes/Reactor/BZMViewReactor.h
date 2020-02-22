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
@property (nonatomic, strong, readonly) NSDictionary *parameters;
@property (nonatomic, strong, readonly) BZMProvider *provider;
@property (nonatomic, strong, readonly) BZMNavigator *navigator;
@property (nonatomic, strong) NSArray *dataSource;
@property (nonatomic, strong) NSString *title;

/// 自有响应式命令/信号的初始化
- (void)didInitialize;

@end

