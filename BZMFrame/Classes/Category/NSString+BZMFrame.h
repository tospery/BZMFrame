//
//  NSString+BZMFrame.h
//  Pods
//
//  Created by 杨建祥 on 2020/1/5.
//

#import <UIKit/UIKit.h>

@interface NSString (BZMFrame)
@property (nonatomic, assign, readonly) BOOL bzm_isPureInt;
@property (nonatomic, copy, readonly) NSString *bzm_underlineFromCamel;
@property (nonatomic, copy, readonly) NSString *bzm_camelFromUnderline;
@property (nonatomic, copy, readonly) NSString *bzm_firstCharLower;
@property (nonatomic, copy, readonly) NSString *bzm_firstCharUpper;
@property (nonatomic, strong, readonly) NSURL *bzm_url;

- (NSString *)bzm_urlEncoded;
- (NSString *)bzm_urlDecoded;
- (NSString *)bzm_urlComponentEncoded;
- (NSString *)bzm_urlComponentDecoded;

+ (NSString *)bzm_stringWithObject:(id)value;
+ (NSString *)bzm_filePathInDocuments:(NSString *)fileName;

@end

