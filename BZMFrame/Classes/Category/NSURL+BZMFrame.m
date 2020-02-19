//
//  NSURL+BZMFrame.m
//  Pods
//
//  Created by 杨建祥 on 2020/1/5.
//

#import "NSURL+BZMFrame.h"
#import <QMUIKit/QMUIKit.h>
#import "BZMFunction.h"
#import "BZMFrameManager.h"
#import "NSObject+BZMFrame.h"
#import "NSString+BZMFrame.h"
#import "UIApplication+BZMFrame.h"

@implementation NSURL (BZMFrame)
- (NSURL *)bzm_addQueries:(NSDictionary *)queries {
    if (!queries || ![queries isKindOfClass:NSDictionary.class] || !queries.count) {
        return self;
    }

    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithDictionary:self.qmui_queryItems];
    for (NSString *key in queries.allKeys) {
        [params setObject:queries[key] forKey:key];
    }

    NSMutableString *urlString = [NSMutableString stringWithFormat:@"%@://%@%@?", self.scheme, self.host, self.path];
    for (NSString *key in params.allKeys) {
        id obj = params[key];
        NSString *value = nil;
        if ([obj isKindOfClass:[NSString class]]) {
            value = obj;
        }else if ([obj isKindOfClass:[NSNumber class]]) {
            value = [(NSNumber *)obj stringValue];
        }else {
            value = [obj bzm_JSONString];
        }
        value = [value bzm_urlComponentEncoded];
        if (value.length != 0) {
            [urlString appendFormat:@"%@=%@&", key, value];
        }
    }
    if ([urlString hasSuffix:@"?"] || [urlString hasSuffix:@"&"]) {
        [urlString deleteCharactersInRange:NSMakeRange(urlString.length - 1, 1)];
    }

    return [NSURL URLWithString:urlString];
}

+ (NSURL *)bzm_urlWithString:(NSString *)urlString {
    if (!urlString || ![urlString isKindOfClass:NSString.class] || !urlString.length) {
        return nil;
    }
    return [NSURL URLWithString:[urlString bzm_urlEncoded]];
}

+ (NSURL *)bzm_urlWithPath:(NSString *)path {
    if (!path || ![path isKindOfClass:NSString.class] || !path.length || [path isEqualToString:@"/"]) {
        return nil;
    }
    
    NSString *pathString = path;
    if ([pathString hasPrefix:@"/"]) {
        pathString = [pathString substringFromIndex:1];
    }
    NSString *baseString = BZMFrameManager.share.baseURLString;
    if (baseString.length == 0) {
        baseString = BZMStrWithFmt(@"https://m.%@.com", UIApplication.sharedApplication.bzm_urlScheme);
    }
    NSString *urlString = BZMStrWithFmt(@"%@/%@", baseString, pathString);
    
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
    NSString *urlString = BZMStrWithFmt(@"%@://%@", UIApplication.sharedApplication.bzm_urlScheme, pathString);
    
    return [NSURL URLWithString:urlString];
}

@end
