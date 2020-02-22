//
//  BZMViewReactor.m
//  Pods
//
//  Created by 杨建祥 on 2020/2/22.
//

#import "BZMViewReactor.h"
#import "BZMAppDependency.h"
#import "BZMParameter.h"
#import "NSDictionary+BZMFrame.h"

@interface BZMViewReactor ()
@property (nonatomic, strong, readwrite) NSDictionary *parameters;
@property (nonatomic, strong, readwrite) BZMProvider *provider;
@property (nonatomic, strong, readwrite) BZMNavigator *navigator;

@end

@implementation BZMViewReactor

#pragma mark - Init
- (instancetype)initWithRouteParameters:(NSDictionary *)parameters {
    if (self = [super init]) {
        self.parameters = parameters;
        self.title = BZMStrMember(parameters, BZMParameter.title, nil);
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

- (BZMNavigator *)navigator {
    if (!_navigator) {
        _navigator = BZMAppDependency.sharedInstance.navigator;
    }
    return _navigator;
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
