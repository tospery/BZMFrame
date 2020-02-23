//
//  UIFont+BZMFrame.h
//  Pods
//
//  Created by 杨建祥 on 2020/2/23.
//

#import <UIKit/UIKit.h>

#define BZMFont(x)                           ([UIFont bzm_fontWithNormal:(x)])
#define BZMFontBold(x)                       ([UIFont bzm_fontWithBold:(x)])
#define BZMFontLight(x)                      ([UIFont bzm_fontWithLight:(x)])

@interface UIFont (BZMFrame)

+ (UIFont *)bzm_fontWithNormal:(CGFloat)size;
+ (UIFont *)bzm_fontWithBold:(CGFloat)size;
+ (UIFont *)bzm_fontWithLight:(CGFloat)size;

@end

