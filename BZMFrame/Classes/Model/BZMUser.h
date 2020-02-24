//
//  BZMUser.h
//  Pods
//
//  Created by 杨建祥 on 2020/2/23.
//

#import "BZMBaseModel.h"

@interface BZMUser : BZMBaseModel
@property (nonatomic, assign) BOOL isLogined;

- (void)logout;

@end

