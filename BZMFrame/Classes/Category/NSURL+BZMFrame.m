//
//  NSURL+BZMFrame.m
//  Pods
//
//  Created by 杨建祥 on 2020/2/22.
//

#import "NSURL+BZMFrame.h"
#import "BZMFrameManager.h"
#import "NSString+BZMFrame.h"

@implementation NSURL (BZMFrame)

+ (NSURL *)bzm_urlWithPath:(NSString *)path {
    if (!path || ![path isKindOfClass:NSString.class] || !path.length || [path isEqualToString:@"/"]) {
        return nil;
    }
    NSString *pathString = path;
    if ([pathString hasPrefix:@"/"]) {
        pathString = [pathString substringFromIndex:1];
    }
    NSString *urlString = BZMStrWithFmt(@"%@/%@", BZMFrameManager.sharedInstance.baseURLString, pathString);
    return [NSURL URLWithString:urlString];
}

+ (NSURL *)bzm_urlWithPattern:(NSString *)pattern {
    if (!pattern || ![pattern isKindOfClass:NSString.class] || !pattern.length || [pattern isEqualToString:@"/"]) {
        return nil;
    }
    NSString *pathString = pattern;
    if ([pathString hasPrefix:@"/"]) {
        pathString = [pathString substringFromIndex:1];
    }
    NSString *urlString = BZMStrWithFmt(@"%@://%@", BZMFrameManager.sharedInstance.appScheme, pathString);
    return [NSURL URLWithString:urlString];
}

@end
