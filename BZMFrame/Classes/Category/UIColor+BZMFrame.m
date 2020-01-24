//
//  UIColor+BZMFrame.m
//  Pods
//
//  Created by 杨建祥 on 2020/1/3.
//

#import "UIColor+BZMFrame.h"

@implementation UIColor (BZMFrame)
+ (UIColor *)bzm_colorWithHex:(NSInteger)hexValue {
    return [UIColor bzm_colorWithHex:hexValue alpha:1.0];
}

+ (UIColor *)bzm_colorWithHex:(NSInteger)hexValue alpha:(CGFloat)alpha {
    CGFloat red = ((CGFloat)((hexValue & 0xFF0000) >> 16)) / 255.0;
    CGFloat green = ((CGFloat)((hexValue & 0xFF00) >> 8)) / 255.0;
    CGFloat blue = ((CGFloat)(hexValue & 0xFF))/255.0;
    return [UIColor colorWithRed:red green:green blue:blue alpha:alpha];
}

@end
