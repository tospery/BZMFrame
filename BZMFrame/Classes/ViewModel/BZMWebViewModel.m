//
//  BZMWebViewModel.m
//  Pods
//
//  Created by 杨建祥 on 2020/1/8.
//

#import "BZMWebViewModel.h"
#import <JLRoutes/JLRoutes.h>
#import "BZMConst.h"
#import "BZMFunction.h"
#import "BZMParam.h"
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
        self.nativeHandlers = BZMArrMember(parameters, BZMParam.nativeHandlers, nil);
        self.jsHandlers = BZMArrMember(parameters, BZMParam.jsHandlers, nil);
        self.url = BZMObjWithDft(BZMURLMember(parameters, JLRouteURLKey, nil), BZMURLMember(parameters, BZMParam.url, nil));
        self.progressColor = BZMColorKey(TINT);
    }
    return self;
}


@end
