//
//  BZMUser.m
//  Pods
//
//  Created by 杨建祥 on 2020/1/5.
//

#import "BZMUser.h"
#import <Mantle/Mantle.h>
#import "BZMConstant.h"
#import "BZMFunction.h"

@interface BZMUser ()

@end

@implementation BZMUser

- (void)logout {
    [self mergeValuesForKeysFromModel:[[self.class alloc] init]];
}

@end
