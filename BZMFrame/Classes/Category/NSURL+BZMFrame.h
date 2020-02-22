//
//  NSURL+BZMFrame.h
//  Pods
//
//  Created by 杨建祥 on 2020/2/22.
//

#import <UIKit/UIKit.h>

#define BZMURLWithStr(x)                    ([NSURL URLWithString:(x)])
#define BZMURLWithPath(x)                   ([NSURL bzm_urlWithPath:(x)])
#define BZMURLWithPattern(x)                ([NSURL bzm_urlWithPattern:(x)])

@interface NSURL (BZMFrame)

+ (NSURL *)bzm_urlWithPath:(NSString *)path;
+ (NSURL *)bzm_urlWithPattern:(NSString *)pattern;

@end
