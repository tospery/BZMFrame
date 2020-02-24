//
//  NSString+BZMFrame.h
//  Pods
//
//  Created by 杨建祥 on 2020/2/22.
//

#import <UIKit/UIKit.h>

#define BZMStrWithBool(x)                    ((x) ? @"YES" : @"NO")
#define BZMStrWithInt(x)                     ([NSString stringWithFormat:@"%llu", ((unsigned long long)x)])
#define BZMStrWithFlt(x)                     ([NSString stringWithFormat:@"%.2f", (x)])
#define BZMStrWithFmt(fmt, ...)              ([NSString stringWithFormat:(fmt), ##__VA_ARGS__])

@interface NSString (BZMFrame)
@property (nonatomic, strong, readonly) NSString *bzm_underlineFromCamel;
@property (nonatomic, strong, readonly) NSString *bzm_camelFromUnderline;

- (NSString *)bzm_urlEncoded;
- (NSString *)bzm_urlDecoded;
- (NSString *)bzm_urlComponentEncoded;
- (NSString *)bzm_urlComponentDecoded;

+ (NSString *)bzm_stringWithObject:(id)object;
+ (NSString *)bzm_filePathInDocuments:(NSString *)fileName;

@end

