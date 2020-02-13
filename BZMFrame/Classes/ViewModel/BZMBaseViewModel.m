//
//  BZMBaseViewModel.m
//  ReactHub
//
//  Created by 杨建祥 on 2019/12/29.
//  Copyright © 2019 杨建祥. All rights reserved.
//

#import "BZMBaseViewModel.h"
#import <Toast/UIView+Toast.h>
#import "BZMConstant.h"
#import "BZMFunction.h"
#import "BZMString.h"
#import "BZMParameter.h"
#import "NSObject+BZMFrame.h"
#import "NSDictionary+BZMFrame.h"
#import "NSError+BZMFrame.h"
#import "BZMBaseViewController.h"

@interface BZMBaseViewModel ()
@property (nonatomic, copy, readwrite) NSDictionary<NSString *,id> *parameters;;
@property (nonatomic, strong, readwrite) BZMBaseModel *model;
@property (nonatomic, strong, readwrite) NSArray *items;
@property (nonatomic, strong, readwrite) BZMNavigator *navigator;
@property (nonatomic, strong, readwrite) BZMProvider *provider;
@property (nonatomic, strong, readwrite) RACSubject *errors;
@property (nonatomic, strong, readwrite) RACSubject *executing;
@property (nonatomic, strong, readwrite) RACSubject *willDisappearSignal;
@property (nonatomic, strong, readwrite) RACCommand *backCommand;
@property (nonatomic, strong, readwrite) RACCommand *closeCommand;
@property (nonatomic, strong, readwrite) RACCommand *requestRemoteDataCommand;
@property (nonatomic, strong, readwrite) RACSignal *reloadSignal;

@end

@implementation BZMBaseViewModel

#pragma mark - Init
- (instancetype)initWithRouteParameters:(NSDictionary<NSString *,id> *)parameters {
    if (self = [super init]) {
        self.parameters = parameters;
        self.shouldFetchLocalData = BZMBoolMember(parameters, BZMParameter.fetchLocal, YES);
        self.shouldRequestRemoteData = BZMBoolMember(parameters, BZMParameter.requestRemote, NO);
        self.hidesNavigationBar = BZMBoolMember(parameters, BZMParameter.hideNavBar, NO);
        self.hidesNavBottomLine = BZMBoolMember(parameters, BZMParameter.hideNavLine, NO);
        self.title = BZMStrMember(parameters, BZMParameter.title, nil);
        id modelObject = BZMStrMember(parameters, BZMParameter.model, nil).bzm_JSONObject;
        if (modelObject && [modelObject isKindOfClass:NSDictionary.class]) {
            Class modelClass = NSClassFromString([NSStringFromClass(self.class) stringByReplacingOccurrencesOfString:kBZMVMSuffix withString:@""]);
            if (modelClass) {
                self.model = [[modelClass alloc] initWithDictionary:(NSDictionary *)modelObject error:nil];
            }
        }
    }
    return self;
}

- (void)dealloc {
    
}

#pragma mark - Property
- (RACSubject *)errors {
    if (!_errors) {
        _errors = [RACSubject subject];
    }
    return _errors;
}

- (RACSubject *)executing {
    if (!_executing) {
        _executing = [RACSubject subject];
    }
    return _executing;
}

- (RACSubject *)willDisappearSignal {
    if (!_willDisappearSignal) {
        _willDisappearSignal = [RACSubject subject];
    }
    return _willDisappearSignal;
}

- (BZMNavigator *)navigator {
    if (!_navigator) {
        _navigator = BZMNavigator.share;
    }
    return _navigator;
}

- (BZMProvider *)provider {
    if (!_provider) {
        _provider = BZMProvider.share;
    }
    return _provider;
}

- (NSArray *)items {
    if ([self.dataSource isKindOfClass:NSArray.class]) {
        NSArray *items = self.dataSource.firstObject;
        if ([items isKindOfClass:NSArray.class]) {
            return items;
        }
    }
    return nil;
}

#pragma mark - Public
- (void)didInitialize {
    @weakify(self)
    [[self.executing skip:1] subscribeNext:^(NSNumber * _Nullable executing) {
        @strongify(self)
        if (executing.boolValue) {
            self.viewController.view.userInteractionEnabled = NO;
            [self.viewController.view makeToastActivity:CSToastPositionCenter];
        } else {
            self.viewController.view.userInteractionEnabled = YES;
            [self.viewController.view hideToastActivity];
        }
    }];
    [self.errors subscribeNext:^(NSError *error) {
        @strongify(self)
        [self.viewController.view makeToast:BZMStrWithDft(error.bzm_displayMessage, kStringErrorUnknown)];
    }];
    
    self.backCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(UIButton *button) {
        @strongify(self)
        [self.navigator popViewModelAnimated:YES];
        return RACSignal.empty;
    }];
    self.closeCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(UIButton *button) {
        @strongify(self)
        [self.navigator dismissViewModelAnimated:YES completion:nil];
        return RACSignal.empty;
    }];
    
//    [[[RACObserve(self, dataSource) skip:1] deliverOnMainThread] subscribeNext:^(id x) {
//        @strongify(self)
//        self.items = nil;
//    }];
    
    self.requestRemoteDataCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(NSNumber *page) {
        @strongify(self)
        return [[self requestRemoteDataSignalWithPage:page.integerValue] takeUntil:self.rac_willDeallocSignal];
    }];
    [[self.requestRemoteDataCommand.errors filter:self.requestRemoteDataErrorsFilter] subscribe:self.errors];
    
    // RACSignal *fetchLocalDataSignal = [RACSignal return:[self fetchLocalData]];
    RACSignal *requestRemoteDataSignal = self.requestRemoteDataCommand.executionSignals.switchToLatest;
    if (self.shouldFetchLocalData && !self.shouldRequestRemoteData) {
        self.reloadSignal = [RACSignal return:[self fetchLocalData]].deliverOnMainThread;
        RAC(self, dataSource) = [self.reloadSignal map:^id(id data) {
            @strongify(self)
            return [self data2Source:data];
        }];
    }else if (!self.shouldFetchLocalData && self.shouldRequestRemoteData) {
        self.reloadSignal = requestRemoteDataSignal.deliverOnMainThread;
        RAC(self, dataSource) = [self.reloadSignal map:^id(id data) {
            @strongify(self)
            return [self data2Source:data];
        }];
    }else if (self.shouldFetchLocalData && self.shouldRequestRemoteData) {
        self.reloadSignal = [requestRemoteDataSignal startWith:[self fetchLocalData]].deliverOnMainThread;
        RAC(self, dataSource) = [self.reloadSignal map:^id(id data) {
            return [self data2Source:data];
        }];
    } else {
        self.reloadSignal = RACSignal.empty;
    }
}

- (NSArray *)data2Source:(id)data {
    return nil;
}

- (id)fetchLocalData {
    return nil;
}

- (RACSignal *)requestRemoteDataSignalWithPage:(NSInteger)page {
    return RACSignal.empty;
}

- (BOOL (^)(NSError *error))requestRemoteDataErrorsFilter {
    @weakify(self)
    return ^(NSError *error) {
        @strongify(self)
        self.error = error;
        BOOL handled = ![self.viewController handleError];
        return handled;
    };
}

#pragma mark - Class
+ (instancetype)allocWithZone:(struct _NSZone *)zone {
    BZMBaseViewModel *viewModel = [super allocWithZone:zone];
    @weakify(viewModel)
    [[viewModel rac_signalForSelector:@selector(initWithRouteParameters:)] subscribeNext:^(id x) {
        @strongify(viewModel)
        [viewModel didInitialize];
    }];
    return viewModel;
}

@end
