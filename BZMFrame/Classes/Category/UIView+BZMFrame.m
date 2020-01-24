//
//  UIView+BZMFrame.m
//  ReactHub
//
//  Created by 杨建祥 on 2019/12/30.
//  Copyright © 2019 杨建祥. All rights reserved.
//

#import "UIView+BZMFrame.h"
#import <QMUIKit/QMUIKit.h>

@implementation UIView (BZMFrame)
- (CGFloat)bzm_borderWidth {
    return self.layer.borderWidth;
}

- (void)setBzm_borderWidth:(CGFloat)borderWidth {
    self.layer.borderWidth = borderWidth;
}

- (CGFloat)bzm_cornerRadius {
    return self.layer.cornerRadius;
}

- (void)setBzm_cornerRadius:(CGFloat)cornerRadius {
    self.layer.masksToBounds = YES;
    self.layer.cornerRadius = flat(cornerRadius);
}

- (UIColor *)bzm_borderColor {
    if (!self.layer.borderColor) {
        return nil;
    }
    return [[UIColor alloc] initWithCGColor:self.layer.borderColor];
}

- (void)setBzm_borderColor:(UIColor *)borderColor {
    self.layer.borderColor = borderColor.CGColor;
}

@end
