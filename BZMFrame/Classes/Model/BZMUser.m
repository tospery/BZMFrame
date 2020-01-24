//
//  BZMUser.m
//  Pods
//
//  Created by 杨建祥 on 2020/1/5.
//

#import "BZMUser.h"
#import "BZMConst.h"
#import "BZMFunction.h"

@interface BZMUser ()

@end

@implementation BZMUser
// YBZM_TODO 使用keyvalues的方式设置属性
- (void)login:(BZMUser *)user {
    [self updateMid:user.mid];
    BZMNotify(kBZMUserWillLoginNotification, self, nil);
    self.isLogined = YES;
    BZMNotify(kBZMUserDidLoginNotification, self, nil);
}

- (void)logout {
    [self updateMid:nil];
    BZMNotify(kBZMUserWillLogoutNotification, self, nil);
    self.isLogined = NO;
    BZMNotify(kBZMUserDidLogoutNotification, self, nil);
}

@end
