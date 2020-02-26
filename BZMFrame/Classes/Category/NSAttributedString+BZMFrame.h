//
//  NSAttributedString+BZMFrame.h
//  Pods
//
//  Created by 杨建祥 on 2020/2/26.
//

#import <UIKit/UIKit.h>

@interface NSAttributedString (BZMFrame)
+ (NSAttributedString *)bzm_attributedStringWithString:(NSString *)string;
+ (NSAttributedString *)bzm_attributedStringWithString:(NSString *)string color:(UIColor *)color font:(UIFont *)font;

@end

