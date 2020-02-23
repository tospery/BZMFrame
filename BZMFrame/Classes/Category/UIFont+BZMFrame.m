//
//  UIFont+BZMFrame.m
//  Pods
//
//  Created by 杨建祥 on 2020/2/23.
//

#import "UIFont+BZMFrame.h"
#import <QMUIKit/QMUIKit.h>
#import "BZMFrameManager.h"

@implementation UIFont (BZMFrame)

+ (UIFont *)bzm_fontWithNormal:(CGFloat)size {
    return [UIFont systemFontOfSize:(size + BZMFrameManager.sharedInstance.fontScale)];
}

+ (UIFont *)bzm_fontWithBold:(CGFloat)size {
    return [UIFont boldSystemFontOfSize:(size + BZMFrameManager.sharedInstance.fontScale)];
}

+ (UIFont *)bzm_fontWithLight:(CGFloat)size {
    return [UIFont qmui_lightSystemFontOfSize:(size + BZMFrameManager.sharedInstance.fontScale)];
}

@end
