//
//  NSString+BZMFrame.h
//  Pods
//
//  Created by 杨建祥 on 2020/2/22.
//

#import <UIKit/UIKit.h>

@interface NSString (BZMFrame)
@property (nonatomic, strong, readonly) NSString *bzm_underlineFromCamel;
@property (nonatomic, strong, readonly) NSString *bzm_camelFromUnderline;

+ (NSString *)bzm_stringWithObject:(id)object;

@end

