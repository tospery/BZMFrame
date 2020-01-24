//
//  NSAttributedString+BZMFrame.m
//  Pods
//
//  Created by 杨建祥 on 2020/1/7.
//

#import "NSAttributedString+BZMFrame.h"

@implementation NSAttributedString (BZMFrame)
+ (NSAttributedString *)bzm_attributedStringWithString:(NSString *)string {
    return [self bzm_attributedStringWithString:string color:nil font:nil];
}

+ (NSAttributedString *)bzm_attributedStringWithString:(NSString *)string color:(UIColor *)color font:(UIFont *)font {
    if (!string || ![string isKindOfClass:NSString.class]) {
        return nil;
    }
    NSMutableDictionary *attributes = [NSMutableDictionary dictionary];
    if (color) {
        [attributes setObject:color forKey:NSForegroundColorAttributeName];
    }
    if (font) {
        [attributes setObject:font forKey:NSFontAttributeName];
    }
    return [[NSAttributedString alloc] initWithString:string attributes:attributes];
}

@end
