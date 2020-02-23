//
//  UIScrollView+BZMFrame.m
//  Pods
//
//  Created by 杨建祥 on 2020/2/23.
//

#import "UIScrollView+BZMFrame.h"
#import <objc/runtime.h>
#import <QMUIKit/QMUIKit.h>

@implementation UIScrollView (BZMFrame)
//+ (void)load {
//    static dispatch_once_t onceToken;
//    dispatch_once(&onceToken, ^{
//        ExchangeImplementations(self.class, @selector(setFrame:), @selector(bzm_setFrame:));
//    });
//}
//
//- (void)bzm_setFrame:(CGRect)frame {
//    [self bzm_setFrame:frame];
//    self.bzm_contentView.frame = self.bounds;
//}

static char kAssociatedObjectKey_contentView;
- (void)setBzm_contentView:(UIView *)bzm_contentView {
    UIView *contentView = self.bzm_contentView;
    if (contentView) {
        [contentView removeFromSuperview];
    }
    if (bzm_contentView) {
        [self addSubview:bzm_contentView];
        bzm_contentView.frame = self.bounds;
    }
    objc_setAssociatedObject(self, &kAssociatedObjectKey_contentView, bzm_contentView, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (UIView *)bzm_contentView {
    return (UIView *)objc_getAssociatedObject(self, &kAssociatedObjectKey_contentView);
}

@end
