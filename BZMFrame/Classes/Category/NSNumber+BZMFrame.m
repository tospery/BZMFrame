//
//  NSNumber+BZMFrame.m
//  Pods
//
//  Created by 杨建祥 on 2020/1/6.
//

#import "NSNumber+BZMFrame.h"

@implementation NSNumber (BZMFrame)

+ (NSNumber *)bzm_numberWithObject:(id)value {
    if ([value isKindOfClass:NSNumber.class]) {
        return value;
    }else if ([value isKindOfClass:NSString.class]) {
        NSString *string = (NSString *)value;
        return @(string.integerValue);
    }
    return nil;
}

@end
