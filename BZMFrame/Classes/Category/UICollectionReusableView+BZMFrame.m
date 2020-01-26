//
//  UICollectionReusableView+BZMFrame.m
//  Pods
//
//  Created by 杨建祥 on 2020/1/26.
//

#import "UICollectionReusableView+BZMFrame.h"
#import "BZMFunction.h"

@implementation UICollectionReusableView (BZMFrame)
+ (NSString *)bzm_reuseId {
    return BZMStrWithFmt(@"%@Identifier", NSStringFromClass(self));
}

@end
