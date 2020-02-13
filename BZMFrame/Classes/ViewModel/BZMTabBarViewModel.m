//
//  BZMTabBarViewModel.m
//  Pods
//
//  Created by 杨建祥 on 2019/12/31.
//

#import "BZMTabBarViewModel.h"

@implementation BZMTabBarViewModel
- (instancetype)initWithRouteParameters:(NSDictionary<NSString *,id> *)parameters {
    if (self = [super initWithRouteParameters:parameters]) {
        self.hidesNavigationBar = BZMBoolMember(parameters, BZMParameter.hideNavBar, YES);
    }
    return self;
}

@end
