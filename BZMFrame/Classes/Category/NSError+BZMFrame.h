//
//  NSError+BZMFrame.h
//  Pods
//
//  Created by 杨建祥 on 2020/1/11.
//

#import <UIKit/UIKit.h>
#import "BZMType.h"

//NSString * BZMErrorCodeString(BZMErrorCode code);

@interface NSError (BZMFrame)
@property (nonatomic, assign, readonly) BOOL bzm_isNetwork;
@property (nonatomic, assign, readonly) BOOL bzm_isServer;
@property (nonatomic, strong, readonly) NSString *bzm_retryTitle;
@property (nonatomic, strong, readonly) NSString *bzm_displayTitle;
@property (nonatomic, strong, readonly) NSString *bzm_displayMessage;
@property (nonatomic, strong, readonly) UIImage *bzm_displayImage;

- (NSError *)bzm_adaptError;

//- (NSString *)bzm_retryTitle;
//- (UIImage *)bzm_reasonImage;

//+ (NSError *)bzm_errorWithCode:(BZMErrorCode)code;

+ (NSError *)bzm_errorWithCode:(NSInteger)code;
+ (NSError *)bzm_errorWithCode:(NSInteger)code description:(NSString *)description;

@end

