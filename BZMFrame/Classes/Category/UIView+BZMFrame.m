//
//  UIView+BZMFrame.m
//  ReactHub
//
//  Created by 杨建祥 on 2019/12/30.
//  Copyright © 2019 杨建祥. All rights reserved.
//

#import "UIView+BZMFrame.h"
#import <QMUIKit/QMUIKit.h>
#import <Toast/UIView+Toast.h>
#import "BZMType.h"
#import "BZMFunction.h"
#import "BZMParameter.h"

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

- (BZMBorderLayer *)bzm_borderLayer {
    if ([self.layer isKindOfClass:BZMBorderLayer.class]) {
        return (BZMBorderLayer *)self.layer;
    }
    return nil;
}

- (BOOL)bzm_toastWithParameters:(NSDictionary *)parameters completion:(void(^)(BOOL didTap))completion {
    NSString *title = BZMStrMember(parameters, BZMParameter.title, nil);
    NSString *message = BZMStrMember(parameters, BZMParameter.message, nil);
    if (title.length == 0 && message.length == 0) {
        return NO;
    }
    CGFloat duration = BZMFltMember(parameters, BZMParameter.duration, 1.5f);
    id position = BZMStrMember(parameters, BZMParameter.position, @"center");
    if ([position isEqualToString:@"top"]) {
        position = CSToastPositionTop;
    } else if ([position isEqualToString:@"bottom"]) {
        position = CSToastPositionBottom;
    } else {
        position = CSToastPositionCenter;
    }
    [self makeToast:message duration:duration position:position title:title image:nil style:nil completion:completion];
    return YES;
}

@end
