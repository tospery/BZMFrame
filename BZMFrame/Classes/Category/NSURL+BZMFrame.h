//
//  NSURL+BZMFrame.h
//  Pods
//
//  Created by 杨建祥 on 2020/1/5.
//

#import <UIKit/UIKit.h>

@interface NSURL (BZMFrame)

- (NSURL *)bzm_addQueries:(NSDictionary *)queries;

+ (NSURL *)bzm_urlWithString:(NSString *)urlString;
+ (NSURL *)bzm_urlWithPath:(NSString *)path;
+ (NSURL *)bzm_urlWithPattern:(NSString *)pattern;

@end

