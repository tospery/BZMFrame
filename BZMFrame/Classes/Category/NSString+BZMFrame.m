//
//  NSString+BZMFrame.m
//  Pods
//
//  Created by 杨建祥 on 2020/2/22.
//

#import "NSString+BZMFrame.h"

@implementation NSString (BZMFrame)

#pragma mark - Instance
- (NSString *)bzm_underlineFromCamel {
    if (self.length == 0) return self;
    NSMutableString *string = [NSMutableString string];
    for (NSUInteger i = 0; i<self.length; i++) {
        unichar c = [self characterAtIndex:i];
        NSString *cString = [NSString stringWithFormat:@"%c", c];
        NSString *cStringLower = [cString lowercaseString];
        if ([cString isEqualToString:cStringLower]) {
            [string appendString:cStringLower];
        } else {
            [string appendString:@"_"];
            [string appendString:cStringLower];
        }
    }
    return string;
}

- (NSString *)bzm_camelFromUnderline {
    if (self.length == 0) return self;
    NSMutableString *string = [NSMutableString string];
    NSArray *cmps = [self componentsSeparatedByString:@"_"];
    for (NSUInteger i = 0; i<cmps.count; i++) {
        NSString *cmp = cmps[i];
        if (i && cmp.length) {
            [string appendString:[NSString stringWithFormat:@"%c", [cmp characterAtIndex:0]].uppercaseString];
            if (cmp.length >= 2) [string appendString:[cmp substringFromIndex:1]];
        } else {
            [string appendString:cmp];
        }
    }
    return string;
}

// YJX_TODO 兼容性，变为属性
- (NSString *)bzm_urlEncoded {
    NSString *str = [self bzm_urlDecoded]; // 避免两次encode
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
    NSString *result = CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(NULL, (__bridge CFStringRef)str, NULL, NULL, kCFStringEncodingUTF8));
#pragma clang diagnostic pop
    return result;
}

- (NSString *)bzm_urlDecoded {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
    NSString *result = CFBridgingRelease(CFURLCreateStringByReplacingPercentEscapesUsingEncoding(NULL, (__bridge CFStringRef)self, CFSTR(""), kCFStringEncodingUTF8));
#pragma clang diagnostic pop
    return result;
}

- (NSString *)bzm_urlComponentEncoded {
    NSString *str = [self bzm_urlComponentDecoded]; // 避免两次encode
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
    NSString *result = CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(NULL,(__bridge CFStringRef)str, NULL,(CFStringRef)@":/?#[]@!$ &'()*+,;=\"<>%{}|\\^~`",kCFStringEncodingUTF8));
#pragma clang diagnostic pop
    return result;
}

- (NSString *)bzm_urlComponentDecoded {
    return [self bzm_urlDecoded];
}

#pragma mark - Class
+ (NSString *)bzm_stringWithObject:(id)object {
    if ([object isKindOfClass:NSString.class]) {
        return object;
    }else if ([object isKindOfClass:NSNumber.class]) {
        NSNumber *number = (NSNumber *)object;
        return number.stringValue;
    }
    return nil;
}

+ (NSString *)bzm_filePathInDocuments:(NSString *)fileName {
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsPath = [paths objectAtIndex:0];
    return [documentsPath stringByAppendingPathComponent:fileName];
}

@end
