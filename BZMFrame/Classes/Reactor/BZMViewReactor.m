//
//  BZMViewReactor.m
//  Pods
//
//  Created by 杨建祥 on 2020/2/22.
//

#import "BZMViewReactor.h"
#import "BZMType.h"
#import "BZMConstant.h"
#import "BZMFunction.h"
#import "BZMString.h"
#import "BZMAppDependency.h"
#import "BZMParameter.h"
#import "BZMViewController.h"
#import "NSObject+BZMFrame.h"
#import "NSDictionary+BZMFrame.h"
#import "UIViewController+BZMFrame.h"
#import "NSError+BZMFrame.h"

@interface BZMViewReactor ()
@property (nonatomic, strong, readwrite) NSDictionary *parameters;
@property (nonatomic, strong, readwrite) BZMUser *user;
@property (nonatomic, strong, readwrite) BZMProvider *provider;
//@property (nonatomic, strong, readwrite) BZMNavigator *navigator;
//@property (nonatomic, strong, readwrite) RACCommand *backCommand;
//@property (nonatomic, strong, readwrite) RACCommand *didBackCommand;
@property (nonatomic, strong, readwrite) RACSubject *errors;
@property (nonatomic, strong, readwrite) RACSubject *executing;
@property (nonatomic, strong, readwrite) RACSubject *navigate;
@property (nonatomic, strong, readwrite) RACSignal *loadSignal;
@property (nonatomic, strong, readwrite) RACCommand *fetchCommand;
@property (nonatomic, strong, readwrite) RACCommand *requestCommand;
@property (nonatomic, strong, readwrite) RACCommand *resultCommand;

@end

@implementation BZMViewReactor

#pragma mark - Init
- (instancetype)initWithRouteParameters:(NSDictionary *)parameters {
    if (self = [super init]) {
        self.parameters = parameters;
        self.shouldFetchLocalData = BZMBoolMember(parameters, BZMParameter.fetchLocal, YES);
        self.shouldRequestRemoteData = BZMBoolMember(parameters, BZMParameter.requestRemote, NO);
        self.hidesNavigationBar = BZMBoolMember(parameters, BZMParameter.hideNavBar, NO);
        self.hidesNavBottomLine = BZMBoolMember(parameters, BZMParameter.hideNavLine, NO);
        self.title = BZMStrMember(parameters, BZMParameter.title, nil);
        self.animation = BZMStrMember(parameters, BZMParameter.animation, nil);
        // User
        NSDictionary *json = BZMStrMember(parameters, BZMParameter.user, nil).bzm_JSONObject;
        if (json && [json isKindOfClass:NSDictionary.class]) {
            Class class = NSClassFromString(@"User");
            if (class && [class conformsToProtocol:@protocol(MTLJSONSerializing)]) {
                self.user = [MTLJSONAdapter modelOfClass:class fromJSONDictionary:json error:nil];
            } else {
                self.user = [BZMUser current];
            }
        } else {
            Class class = NSClassFromString(@"User");
            if (class && [class isSubclassOfClass:BZMBaseModel.class]) {
                self.user = [class current];
            } else {
                self.user = [BZMUser current];
            }
        }
    }
    return self;
}

- (void)didInitialize {
    [super didInitialize];
    @weakify(self)
    RAC(self, dataSource) = [self.loadSignal map:^id(id data) {
        @strongify(self)
        return [self data2Source:data];
    }];
}

#pragma mark - View
#pragma mark - Property
- (BZMProvider *)provider {
    if (!_provider) {
        _provider = BZMAppDependency.sharedInstance.provider;
    }
    return _provider;
}

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

- (RACSubject *)navigate {
    if (!_navigate) {
        _navigate = [RACSubject subject];
    }
    return _navigate;
}

- (RACSignal *)loadSignal {
    if (!_loadSignal) {
        RACSignal *signal = nil;
        if (self.shouldFetchLocalData && !self.shouldRequestRemoteData) {
            signal = self.fetchCommand.executionSignals.switchToLatest;
        } else if (!self.shouldFetchLocalData && self.shouldRequestRemoteData) {
            signal = self.requestCommand.executionSignals.switchToLatest;
        } else if (self.shouldFetchLocalData && self.shouldRequestRemoteData) {
            signal = [RACSignal merge:@[self.fetchCommand.executionSignals.switchToLatest, self.requestCommand.executionSignals.switchToLatest]];
        } else {
            signal = RACSignal.empty;
        }
        _loadSignal = signal;
    }
    return _loadSignal;
}

- (RACCommand *)fetchCommand {
    if (!_fetchCommand) {
        @weakify(self)
        RACCommand *command = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
            @strongify(self)
            return [RACSignal return:[self fetchLocal]];
        }];
        _fetchCommand = command;
    }
    return _fetchCommand;
}

- (RACCommand *)requestCommand {
    if (!_requestCommand) {
        @weakify(self)
        RACCommand *command = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(NSNumber *page) {
            @strongify(self)
            return [[self requestWithPage:page.integerValue] takeUntil:self.rac_willDeallocSignal];
        }];
        [[command.errors filter:self.errorFilter] subscribe:self.errors];
        _requestCommand = command;
    }
    return _requestCommand;
}

- (RACCommand *)resultCommand {
    if (!_resultCommand) {
        RACCommand *command = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
            return [RACSignal return:input];
        }];
        _resultCommand = command;
    }
    return _resultCommand;
}

#pragma mark - Data
- (id)fetchLocal {
    return nil;
}

- (RACSignal *)requestWithPage:(NSInteger)page {
    return RACSignal.empty;
}

- (NSArray *)data2Source:(id)data {
    return nil;
}

#pragma mark - Error
- (BOOL (^)(NSError *error))errorFilter {
    // @weakify(self)
    return ^(NSError *error) {
//        @strongify(self)
//        self.error = error;
//        BOOL handled = ![self.viewController handleError];
//        return handled;
        return YES;
    };
}

#pragma mark - Delegate

#pragma mark - Class
+ (instancetype)allocWithZone:(struct _NSZone *)zone {
    BZMViewReactor *reactor = [super allocWithZone:zone];
    @weakify(reactor)
    [[reactor rac_signalForSelector:@selector(initWithRouteParameters:)] subscribeNext:^(id x) {
        @strongify(reactor)
        [reactor didInitialize];
    }];
    return reactor;
}

@end
