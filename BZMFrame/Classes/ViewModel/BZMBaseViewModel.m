//
//  BZMBaseViewModel.m
//  ReactHub
//
//  Created by 杨建祥 on 2019/12/29.
//  Copyright © 2019 杨建祥. All rights reserved.
//

#import "BZMBaseViewModel.h"
#import <MBProgressHUD/MBProgressHUD.h>
#import "BZMConst.h"
#import "BZMFunction.h"
#import "BZMString.h"
#import "BZMParam.h"
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
@property (nonatomic, strong, readwrite) RACCommand *requestRemoteDataCommand;

@end

@implementation BZMBaseViewModel
#pragma mark - Init
- (instancetype)initWithRouteParameters:(NSDictionary<NSString *,id> *)parameters {
    if (self = [super init]) {
        self.parameters = parameters;
        self.shouldFetchLocalData = BZMBoolMember(parameters, BZMParam.fetchLocal, YES);
        self.shouldRequestRemoteData = BZMBoolMember(parameters, BZMParam.requestRemote, NO);
        self.hidesNavigationBar = BZMBoolMember(parameters, BZMParam.hideNavBar, NO);
        self.hidesNavBottomLine = BZMBoolMember(parameters, BZMParam.hideNavBottomLine, NO);
        self.title = BZMStrMember(parameters, BZMParam.title, nil);
        id modelObject = BZMStrMember(parameters, BZMParam.model, nil).bzm_JSONObject;
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
            [MBProgressHUD showHUDAddedTo:self.viewController.view animated:YES];
        }
    }];
    [self.errors subscribeNext:^(NSError *error) {
        @strongify(self)
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.viewController.view animated:YES];
        hud.margin = 12;
        hud.mode = MBProgressHUDModeText;
        hud.contentColor = UIColorWhite;
        hud.bezelView.style = MBProgressHUDBackgroundStyleSolidColor;
        hud.bezelView.color = UIColorBlack;
        hud.label.font = BZMFont(15);
        hud.label.text = BZMStrWithDft(error.bzm_displayMessage, kStringUnknownError);
        [hud hideAnimated:YES afterDelay:3.f];
    }];
    
    self.backCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal * _Nonnull(NSNumber * _Nullable isBack) {
        @strongify(self)
        if (isBack.boolValue) {
            [self.navigator popViewModelAnimated:YES];
        }else {
            [self.navigator dismissViewModelAnimated:YES completion:nil];
        }
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
        RAC(self, dataSource) = [[RACSignal return:[self fetchLocalData]].deliverOnMainThread map:^id(id data) {
            @strongify(self)
            return [self data2Source:data];
        }];
    }else if (!self.shouldFetchLocalData && self.shouldRequestRemoteData) {
        RAC(self, dataSource) = [requestRemoteDataSignal.deliverOnMainThread map:^id(id data) {
            @strongify(self)
            return [self data2Source:data];
        }];
    }else if (self.shouldFetchLocalData && self.shouldRequestRemoteData) {
        RAC(self, dataSource) = [[requestRemoteDataSignal startWith:[self fetchLocalData]].deliverOnMainThread map:^id(id data) {
            return [self data2Source:data];
        }];
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
        BOOL result = YES;
        if ([self.delegate respondsToSelector:@selector(handleError)]) {
            result = ![self.delegate handleError];
        }
        return result;
    };
}

//- (BOOL)filterError {
//    return YES;
//}

//- (void)handleError:(NSError *)error {
//    
//}

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
