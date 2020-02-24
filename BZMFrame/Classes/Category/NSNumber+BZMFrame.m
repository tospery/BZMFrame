//
//  NSNumber+BZMFrame.m
//  Pods
//
//  Created by 杨建祥 on 2020/2/23.
//

#import "NSNumber+BZMFrame.h"

@implementation NSNumber (BZMFrame)

+ (NSNumber *)bzm_numberWithObject:(id)object {
    if ([object isKindOfClass:NSNumber.class]) {
        return object;
    }else if ([object isKindOfClass:NSString.class]) {
        NSString *string = (NSString *)object;
        return @(string.integerValue);
    }
    return nil;
}

@end
