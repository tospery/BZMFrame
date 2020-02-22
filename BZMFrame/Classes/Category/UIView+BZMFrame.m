//
//  UIView+BZMFrame.m
//  Pods
//
//  Created by 杨建祥 on 2020/2/22.
//

#import "UIView+BZMFrame.h"
#import <Toast/UIView+Toast.h>
#import "BZMFunction.h"
#import "BZMParameter.h"
#import "NSDictionary+BZMFrame.h"

@implementation UIView (BZMFrame)

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
