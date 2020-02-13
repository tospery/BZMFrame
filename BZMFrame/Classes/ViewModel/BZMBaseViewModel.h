//
//  BZMBaseViewModel.h
//  ReactHub
//
//  Created by 杨建祥 on 2019/12/29.
//  Copyright © 2019 杨建祥. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <ReactiveObjC/ReactiveObjC.h>
#import <JLRoutes/JLRRouteHandler.h>
#import "BZMType.h"
#import "BZMBaseModel.h"
#import "BZMNavigator.h"
#import "BZMProvider.h"

@class BZMBaseViewController;

@protocol BZMBaseViewModelDataSource <NSObject, JLRRouteHandlerTarget>

@end

@interface BZMBaseViewModel : NSObject <BZMBaseViewModelDataSource>
@property (nonatomic, assign) BOOL hidesNavigationBar;
@property (nonatomic, assign) BOOL hidesNavBottomLine;
@property (nonatomic, assign) BOOL shouldFetchLocalData;
@property (nonatomic, assign) BOOL shouldRequestRemoteData;
@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSString *subtitle;
@property (nonatomic, copy, readonly) NSDictionary<NSString *,id> *parameters;
@property (nonatomic, strong, readonly) BZMBaseModel *model;
@property (nonatomic, assign) BZMRequestMode requestMode;
@property (nonatomic, strong) NSError *error;
@property (nonatomic, copy) NSArray *dataSource;
@property (nonatomic, strong, readonly) NSArray *items;
@property (nonatomic, copy) BZMVoidBlock_id callback;
@property (nonatomic, strong, readonly) BZMNavigator *navigator;
@property (nonatomic, strong, readonly) BZMProvider *provider;
@property (nonatomic, strong, readonly) RACSubject *errors;
@property (nonatomic, strong, readonly) RACSubject *executing;
@property (nonatomic, strong, readonly) RACSubject *willDisappearSignal;
@property (nonatomic, strong, readonly) RACCommand *backCommand;
@property (nonatomic, strong, readonly) RACCommand *closeCommand;
@property (nonatomic, strong, readonly) RACCommand *requestRemoteDataCommand;
@property (nonatomic, strong, readonly) RACSignal *reloadSignal;
@property (nonatomic, weak) BZMBaseViewController *viewController;

- (void)didInitialize;
- (NSArray *)data2Source:(id)data;
- (id)fetchLocalData;
- (RACSignal *)requestRemoteDataSignalWithPage:(NSInteger)page;
- (BOOL (^)(NSError *error))requestRemoteDataErrorsFilter;

@end

