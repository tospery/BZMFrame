//
//  BZMProvider.h
//  Pods
//
//  Created by 杨建祥 on 2020/1/4.
//

#import <UIKit/UIKit.h>
#import "BZMProvisionProtocol.h"

@interface BZMProvider : NSObject <BZMProvisionProtocol>

- (void)didInitialize;

+ (instancetype)share;

@end

