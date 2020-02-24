//
//  BZMWebViewReactor.m
//  Pods
//
//  Created by 杨建祥 on 2020/2/23.
//

#import "BZMWebViewReactor.h"
#import <JLRoutes/JLRoutes.h>
#import "BZMConstant.h"
#import "BZMFunction.h"
#import "BZMParameter.h"
#import "NSDictionary+BZMFrame.h"

@interface BZMWebViewReactor ()
@property (nonatomic, strong, readwrite) NSURL *url;

@end

@implementation BZMWebViewReactor
- (instancetype)initWithRouteParameters:(NSDictionary *)parameters {
    if (self = [super initWithRouteParameters:parameters]) {
        self.shouldFetchLocalData = BZMBoolMember(parameters, BZMParameter.requestRemote, NO);
        self.shouldRequestRemoteData = BZMBoolMember(parameters, BZMParameter.requestRemote, YES);
        self.ocHandlers = BZMArrMember(parameters, BZMParameter.ocHandlers, nil);
        self.jsHandlers = BZMArrMember(parameters, BZMParameter.jsHandlers, nil);
        self.url = BZMObjWithDft(BZMURLMember(parameters, JLRouteURLKey, nil), BZMURLMember(parameters, BZMParameter.url, nil));
        self.progressColor = UIColor.redColor; // BZMColorKey(TINT); // YJX_TODO
    }
    return self;
}

@end
