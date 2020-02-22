//
//  NSURL+BZMFrame.m
//  Pods
//
//  Created by 杨建祥 on 2020/2/22.
//

#import "NSURL+BZMFrame.h"
#import "NSString+BZMFrame.h"

@implementation NSURL (BZMFrame)

+ (NSURL *)bzm_urlWithPath:(NSString *)path {
//    if (!path || ![path isKindOfClass:NSString.class] || !path.length || [path isEqualToString:@"/"]) {
//        return nil;
//    }
//
//    NSString *pathString = path;
//    if ([pathString hasPrefix:@"/"]) {
//        pathString = [pathString substringFromIndex:1];
//    }
//    NSString *baseString = BZMFrameManager.share.baseURLString;
//    if (baseString.length == 0) {
//        baseString = BZMStrWithFmt(@"https://m.%@.com", UIApplication.sharedApplication.bzm_urlScheme);
//    }
//    NSString *urlString = BZMStrWithFmt(@"%@/%@", baseString, pathString);
//
//    return [NSURL URLWithString:urlString];
    return nil;
}

+ (NSURL *)bzm_urlWithPattern:(NSString *)pattern {
//    if (!pattern || ![pattern isKindOfClass:NSString.class] || !pattern.length || [pattern isEqualToString:@"/"]) {
//        return nil;
//    }
//    NSString *pathString = pattern;
//    if ([pathString hasPrefix:@"/"]) {
//        pathString = [pathString substringFromIndex:1];
//    }
//    NSString *urlString = BZMStrWithFmt(@"%@://%@", UIApplication.sharedApplication.bzm_urlScheme, pathString);
//
//    return [NSURL URLWithString:urlString];
    return nil;
}

@end
