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
@property (nonatomic, strong, readwrite) NSString *animation;
@property (nonatomic, strong, readwrite) NSDictionary *parameters;
@property (nonatomic, strong, readwrite) BZMUser *user;
@property (nonatomic, strong, readwrite) BZMProvider *provider;
//@property (nonatomic, strong, readwrite) BZMNavigator *navigator;
//@property (nonatomic, strong, readwrite) RACCommand *backCommand;
//@property (nonatomic, strong, readwrite) RACCommand *didBackCommand;
@property (nonatomic, strong, readwrite) RACSubject *errors;
@property (nonatomic, strong, readwrite) RACSubject *executing;
@property (nonatomic, strong, readwrite) RACSubject *navigate;
@property (nonatomic, strong, readwrite) RACCommand *dataCommand;

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
    
}

#pragma mark - View
#pragma mark - Property
- (BZMProvider *)provider {
    if (!_provider) {
        _provider = BZMAppDependency.sharedInstance.provider;
    }
    return _provider;
}

//- (RACCommand *)backCommand {
//    if (!_backCommand) {
//        RACCommand *command = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
//            id data = nil;
//            BZMViewControllerBackType type = BZMViewControllerBackTypePopOne;
//            if ([input isKindOfClass:RACTuple.class]) {
//                RACTuple *tuple = (RACTuple *)input;
//                if ([tuple.first isKindOfClass:NSNumber.class]) {
//                    NSNumber *number = (NSNumber *)tuple.first;
//                    type = number.integerValue;
//                }
//                data = tuple.second;
//            } else if ([input isKindOfClass:NSNumber.class]) {
//                NSNumber *number = (NSNumber *)input;
//                type = number.integerValue;
//            }
//            @weakify(self)
//            BZMVoidBlock completion = ^(void) {
//                @strongify(self)
//                [self.didBackCommand execute:data];
//            };
//            if (BZMViewControllerBackTypePopOne == type) {
//                [self.navigator popReactorAnimated:YES completion:completion];
//            } else if (BZMViewControllerBackTypePopAll == type) {
//                [self.navigator popToRootReactorAnimated:YES completion:completion];
//            } else if (BZMViewControllerBackTypeDismiss == type) {
//                [self.navigator dismissReactorAnimated:YES completion:completion];
//            } else if (BZMViewControllerBackTypeClose == type) {
//                [self.navigator closeReactorWithAnimationType:BZMViewControllerAnimationTypeFromString(self.animation) completion:completion];
//            }
//            return RACSignal.empty;
//        }];
//        _backCommand = command;
//    }
//    return _backCommand;
//}
//
- (RACCommand *)dataCommand {
    if (!_dataCommand) {
        RACCommand *command = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
            return [RACSignal return:input];
        }];
        _dataCommand = command;
    }
    return _dataCommand;
}

- (RACSubject *)errors {
    if (!_errors) {
        RACSubject *subject = [RACSubject subject];
        _errors = subject;
    }
    return _errors;
}

- (RACSubject *)executing {
    if (!_executing) {
        RACSubject *subject = [RACSubject subject];
        _executing = subject;
    }
    return _executing;
}

- (RACSubject *)navigate {
    if (!_navigate) {
        RACSubject *subject = [RACSubject subject];
        _navigate = subject;
    }
    return _navigate;
}

#pragma mark - Bind
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
