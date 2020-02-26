//
//  BZMViewReactor.h
//  Pods
//
//  Created by 杨建祥 on 2020/2/22.
//

#import "BZMBaseReactor.h"
#import <ReactiveObjC/ReactiveObjC.h>
#import <JLRoutes/JLRRouteHandler.h>
#import "BZMUser.h"
#import "BZMProvider.h"

typedef NS_ENUM(NSInteger, BZMRequestMode) {
    BZMRequestModeNone,
    BZMRequestModeLoad,
    BZMRequestModeUpdate,
    BZMRequestModeRefresh,
    BZMRequestModeMore,
    BZMRequestModeActivity
};

@class BZMViewReactor;

@protocol BZMViewReactorDataSource <NSObject, JLRRouteHandlerTarget>

@end

/// 业务逻辑（网络请求/数据处理）
@interface BZMViewReactor : BZMBaseReactor <BZMViewReactorDataSource>
@property (nonatomic, assign) BOOL hidesNavigationBar;
@property (nonatomic, assign) BOOL hidesNavBottomLine;
@property (nonatomic, assign) BOOL shouldFetchLocalData;
@property (nonatomic, assign) BOOL shouldRequestRemoteData;
@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSString *animation;
@property (nonatomic, strong, readonly) NSDictionary *parameters;
@property (nonatomic, strong, readonly) BZMUser *user;
@property (nonatomic, strong) NSArray *dataSource;
@property (nonatomic, strong) NSError *error;
@property (nonatomic, assign) BZMRequestMode requestMode;
@property (nonatomic, strong, readonly) BZMProvider *provider;
@property (nonatomic, strong, readonly) RACSubject *load;
@property (nonatomic, strong, readonly) RACSubject *errors;
@property (nonatomic, strong, readonly) RACSubject *executing;
@property (nonatomic, strong, readonly) RACSubject *navigate;
//@property (nonatomic, strong, readonly) RACSignal *loadSignal;
//@property (nonatomic, strong, readonly) RACCommand *loadCommand;
@property (nonatomic, strong, readonly) RACCommand *resultCommand;
//@property (nonatomic, strong, readonly) RACCommand *fetchLocalCommand;
@property (nonatomic, strong, readonly) RACCommand *requestRemoteCommand;

- (id)fetchLocalData;
- (RACSignal *)requestRemoteSignalWithPage:(NSInteger)page;

- (BOOL (^)(NSError *error))errorFilter;
- (BOOL)handleError;

- (NSArray *)data2Source:(id)data;

@end

