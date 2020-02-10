//
//  BZMWebViewModel.m
//  Pods
//
//  Created by 杨建祥 on 2020/1/8.
//

#import "BZMWebViewModel.h"
#import <JLRoutes/JLRoutes.h>
#import "BZMConstant.h"
#import "BZMFunction.h"
#import "BZMParameter.h"
#import "NSDictionary+BZMFrame.h"

@interface BZMWebViewModel ()
@property (nonatomic, strong, readwrite) NSURL *url;
@property (nonatomic, strong, readwrite) UIColor *progressColor;

@end

@implementation BZMWebViewModel
- (instancetype)initWithRouteParameters:(NSDictionary<NSString *,id> *)parameters {
    if (self = [super initWithRouteParameters:parameters]) {
        self.shouldFetchLocalData = NO;
        self.shouldRequestRemoteData = YES;
        self.ocHandlers = BZMArrMember(parameters, BZMParameter.ocHandlers, nil);
        self.jsHandlers = BZMArrMember(parameters, BZMParameter.jsHandlers, nil);
        self.url = BZMObjWithDft(BZMURLMember(parameters, JLRouteURLKey, nil), BZMURLMember(parameters, BZMParameter.url, nil));
        self.progressColor = BZMColorKey(TINT);
    }
    return self;
}


@end
