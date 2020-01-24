//
//  UIFont+BZMFrame.m
//  Pods
//
//  Created by 杨建祥 on 2020/1/3.
//

#import "UIFont+BZMFrame.h"
#import <QMUIKit/QMUIKit.h>
#import "BZMFrameManager.h"

@implementation UIFont (BZMFrame)

+ (UIFont *)bzm_normal:(CGFloat)size {
    return [UIFont systemFontOfSize:(size + BZMFrameManager.share.fontScale)];
}

+ (UIFont *)bzm_bold:(CGFloat)size {
    return [UIFont boldSystemFontOfSize:(size + BZMFrameManager.share.fontScale)];
}

+ (UIFont *)bzm_light:(CGFloat)size {
    return [UIFont qmui_lightSystemFontOfSize:(size + BZMFrameManager.share.fontScale)];
}

@end
