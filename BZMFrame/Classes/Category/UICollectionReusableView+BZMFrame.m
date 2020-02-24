//
//  UICollectionReusableView+BZMFrame.m
//  Pods
//
//  Created by 杨建祥 on 2020/2/24.
//

#import "UICollectionReusableView+BZMFrame.h"
#import "NSString+BZMFrame.h"

@implementation UICollectionReusableView (BZMFrame)
+ (NSString *)bzm_reuseId {
    return BZMStrWithFmt(@"%@Identifier", NSStringFromClass(self));
}

@end
