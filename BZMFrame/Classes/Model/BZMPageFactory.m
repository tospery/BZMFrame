//
//  BZMPageFactory.m
//  Pods
//
//  Created by 杨建祥 on 2020/1/10.
//

#import "BZMPageFactory.h"
#import <QMUIKit/QMUIKit.h>

@implementation BZMPageFactory
+ (CGFloat)interpolationFrom:(CGFloat)from to:(CGFloat)to percent:(CGFloat)percent {
    percent = MAX(0, MIN(1, percent));
    return from + (to - from)*percent;
}

+ (UIColor *)interpolationColorFrom:(UIColor *)fromColor to:(UIColor *)toColor percent:(CGFloat)percent {
    CGFloat red = [self interpolationFrom:fromColor.qmui_red to:toColor.qmui_red percent:percent];
    CGFloat green = [self interpolationFrom:fromColor.qmui_green to:toColor.qmui_green percent:percent];
    CGFloat blue = [self interpolationFrom:fromColor.qmui_blue to:toColor.qmui_blue percent:percent];
    CGFloat alpha = [self interpolationFrom:fromColor.qmui_alpha to:toColor.qmui_alpha percent:percent];
    return [UIColor colorWithRed:red green:green blue:blue alpha:alpha];
}

@end
