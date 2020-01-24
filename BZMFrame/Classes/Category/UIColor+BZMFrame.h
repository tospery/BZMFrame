//
//  UIColor+BZMFrame.h
//  Pods
//
//  Created by 杨建祥 on 2020/1/3.
//

#import <UIKit/UIKit.h>

@interface UIColor (BZMFrame)
+ (UIColor *)bzm_colorWithHex:(NSInteger)hexValue;
+ (UIColor *)bzm_colorWithHex:(NSInteger)hexValue alpha:(CGFloat)alpha;

@end

