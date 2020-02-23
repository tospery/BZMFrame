//
//  BZMTabBarViewReactor.m
//  Pods
//
//  Created by 杨建祥 on 2020/2/22.
//

#import "BZMTabBarViewReactor.h"
#import "BZMParameter.h"
#import "NSDictionary+BZMFrame.h"

@interface BZMTabBarViewReactor ()
@property (nonatomic, strong, readwrite) RACSubject *selectSubject;

@end

@implementation BZMTabBarViewReactor

#pragma mark - Init
- (instancetype)initWithRouteParameters:(NSDictionary *)parameters {
    if (self = [super initWithRouteParameters:parameters]) {
        self.hidesNavigationBar = BZMBoolMember(parameters, BZMParameter.hideNavBar, YES);
    }
    return self;
}

- (void)didInitialize {
    [super didInitialize];
}

#pragma mark - View
#pragma mark - Property
- (RACSubject *)selectSubject {
    if (!_selectSubject) {
        RACSubject *subject = [RACSubject subject];
        @weakify(self)
        [subject subscribeNext:^(RACTuple *tuple) {
            @strongify(self)
            [self.navigator popNavigationController];
            [self.navigator pushNavigationController:tuple.second];
        }];
        _selectSubject = subject;
    }
    return _selectSubject;
}

#pragma mark - Method
#pragma mark super
#pragma mark public
#pragma mark private
#pragma mark - Delegate
#pragma mark - Class


@end
