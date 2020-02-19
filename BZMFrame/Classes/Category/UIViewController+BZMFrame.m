//
//  UIViewController+BZMFrame.m
//  Pods
//
//  Created by 杨建祥 on 2020/1/9.
//

#import "UIViewController+BZMFrame.h"
#import <objc/runtime.h>
#import <QuartzCore/QuartzCore.h>
#import "BZMFunction.h"
#import "BZMPopupBackgroundView.h"
#import "BZMPageViewController.h"
#import "BZMTabBarViewController.h"

#define kBZMPopupAnimationDuration               (0.25)
#define kBZMPopupDurationTime                    (@"kBZMPopupDurationTime")
#define kBZMPopupViewController                  (@"kBZMPopupViewController")
#define kBZMPopupBackgroundView                  (@"kBZMPopupBackgroundView")
#define kBZMSourceViewTag                        (53941)
#define kBZMPopupViewTag                         (53942)
#define kBZMOverlayViewTag                       (53945)

static NSInteger const kBZMPopupAnimationOptionCurveIOS7 = (7 << 16);
static NSString *kBZMPopupDismissKey = @"kBZMPopupDismissKey";

BZMPopupLayout BZMPopupLayoutMake(BZMPopupLayoutHorizontal horizontal, BZMPopupLayoutVertical vertical) {
    BZMPopupLayout layout;
    layout.horizontal = horizontal;
    layout.vertical = vertical;
    return layout;
}

const BZMPopupLayout BZMPopupLayoutCenter = {BZMPopupLayoutHorizontalCenter, BZMPopupLayoutVerticalCenter};

@interface UIViewController (BZMFrame_Popup)
- (UIView *)bzm_topView;
- (void)presentPopupView:(UIView *)popupView;

@end

@implementation UIViewController (BZMFrame)

static void * const keypath = (void*)&keypath;

#pragma mark - Popup
#pragma mark property
- (UIViewController *)bzm_popupViewController {
    return objc_getAssociatedObject(self, kBZMPopupViewController);
}

- (void)setBzm_popupViewController:(UIViewController *)popupViewController {
    objc_setAssociatedObject(self, kBZMPopupViewController, popupViewController, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (BZMPopupBackgroundView *)bzm_popupBackgroundView {
    return objc_getAssociatedObject(self, kBZMPopupBackgroundView);
}

- (void)setBzm_popupBackgroundView:(BZMPopupBackgroundView *)popupBackgroundView {
    objc_setAssociatedObject(self, kBZMPopupBackgroundView, popupBackgroundView, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (void)setDismissedCallback:(void(^)(void))dismissed {
    objc_setAssociatedObject(self, &kBZMPopupDismissKey, dismissed, OBJC_ASSOCIATION_RETAIN);
}

- (void(^)(void))dismissedCallback {
    return objc_getAssociatedObject(self, &kBZMPopupDismissKey);
}

#pragma mark present
- (void)bzm_presentPopupViewController:(UIViewController*)popupViewController animationType:(BZMPopupPresentAnimationType)animationType layout:(BZMPopupLayout)layout bgTouch:(BOOL)bgTouch dismissed:(void(^)(void))dismissed {
    self.bzm_popupViewController = popupViewController;
    [self presentPopupView:popupViewController.view animationType:animationType layout:layout bgTouch:bgTouch dismissed:dismissed];
}

#pragma mark dismiss
- (void)bzm_dismissPopupViewControllerWithAnimationType:(BZMPopupDismissAnimationType)animationType {
    [self bzm_dismissPopupViewControllerWithAnimationType:animationType dismissed:nil];
}

- (void)bzm_dismissPopupViewControllerWithAnimationType:(BZMPopupDismissAnimationType)animationType dismissed:(void(^)(void))dismissed {
    UIView *sourceView = [self bzm_topView];
    UIView *popupView = [sourceView viewWithTag:kBZMPopupViewTag];
    UIView *overlayView = [sourceView viewWithTag:kBZMOverlayViewTag];
    
    //    switch (animationType) {
    //        case BZMPopupDismissAnimationTypeNone:
    //            [self hideViewOut:popupView sourceView:sourceView overlayView:overlayView];
    //            break;
    //        case BZMPopupDismissAnimationTypeFadeOut:
    //            [self fadeViewOut:popupView sourceView:sourceView overlayView:overlayView];
    //            break;
    //        case BZMPopupDismissAnimationTypeGrowOut:
    //            [self growViewOut:popupView sourceView:sourceView overlayView:overlayView];
    //            break;
    //        case BZMPopupDismissAnimationTypeShrinkOut:
    //            [self shrinkViewOut:popupView sourceView:sourceView overlayView:overlayView];
    //            break;
    //        case BZMPopupDismissAnimationTypeSlideOutToTop:
    //        case BZMPopupDismissAnimationTypeSlideOutToBottom:
    //        case BZMPopupDismissAnimationTypeSlideOutToLeft:
    //        case BZMPopupDismissAnimationTypeSlideOutToRight:
    //            [self slideViewOut:popupView sourceView:sourceView overlayView:overlayView withAnimationType:animationType];
    //            break;
    //        case BZMPopupDismissAnimationTypeBounceOut:
    //        case BZMPopupDismissAnimationTypeBounceOutToTop:
    //        case BZMPopupDismissAnimationTypeBounceOutToBottom:
    //        case BZMPopupDismissAnimationTypeBounceOutToLeft:
    //        case BZMPopupDismissAnimationTypeBounceOutToRight:
    //            [self bounceViewOut:popupView sourceView:sourceView overlayView:overlayView withAnimationType:animationType];
    //            break;
    //        default:
    //            break;
    //    }
    [self hideViewIn:popupView sourceView:sourceView overlayView:overlayView animationType:animationType];
    [self setDismissedCallback:dismissed];
}

#pragma mark view
- (void)presentPopupView:(UIView *)popupView animationType:(BZMPopupPresentAnimationType)animationType layout:(BZMPopupLayout)layout bgTouch:(BOOL)bgTouch dismissed:(void(^)(void))dismissed {
    UIView *sourceView = [self bzm_topView];
    sourceView.tag = kBZMSourceViewTag;
    popupView.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleLeftMargin |UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleRightMargin;
    popupView.tag = kBZMPopupViewTag;
    
    // check if source view controller is not in destination
    if ([sourceView.subviews containsObject:popupView]) return;
    
    // customize popupView
    popupView.layer.shadowPath = [UIBezierPath bezierPathWithRect:popupView.bounds].CGPath;
    popupView.layer.masksToBounds = NO;
    popupView.layer.shadowOffset = CGSizeMake(5, 5);
    popupView.layer.shadowRadius = 5;
    popupView.layer.shadowOpacity = 0.5;
    popupView.layer.shouldRasterize = YES;
    popupView.layer.rasterizationScale = UIScreen.mainScreen.scale;
    
    // Add semi overlay
    UIView *overlayView = [[UIView alloc] initWithFrame:sourceView.bounds];
    overlayView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    overlayView.tag = kBZMOverlayViewTag;
    overlayView.backgroundColor = [UIColor clearColor];
    
    // BackgroundView
    self.bzm_popupBackgroundView = [[BZMPopupBackgroundView alloc] initWithFrame:sourceView.bounds];
    self.bzm_popupBackgroundView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    self.bzm_popupBackgroundView.backgroundColor = [UIColor clearColor];
    self.bzm_popupBackgroundView.alpha = 0.0f;
    [overlayView addSubview:self.bzm_popupBackgroundView];
    
    // Make the Background Clickable
    if (bgTouch) {
        UIButton * dismissButton = [UIButton buttonWithType:UIButtonTypeCustom];
        dismissButton.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        dismissButton.backgroundColor = [UIColor clearColor];
        dismissButton.frame = sourceView.bounds;
        dismissButton.tag = animationType;
        [dismissButton addTarget:self action:@selector(dismissButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
        [overlayView addSubview:dismissButton];
    }
    
    popupView.alpha = 0.0f;
    [overlayView addSubview:popupView];
    [sourceView addSubview:overlayView];
    
    [self showViewIn:popupView sourceView:sourceView overlayView:overlayView animationType:animationType layout:layout];
    [self setDismissedCallback:dismissed];
}

-(UIView *)bzm_topView {
    UIViewController *recentView = self;
    
    while (recentView.parentViewController != nil) {
        recentView = recentView.parentViewController;
    }
    return recentView.view;
}

- (void)dismissButtonPressed:(UIButton *)sender {
    [self bzm_dismissPopupViewControllerWithAnimationType:(BZMPopupDismissAnimationType)sender.tag];
//    if ([sender isKindOfClass:[UIButton class]]) {
//        UIButton* dismissButton = sender;
////        switch (dismissButton.tag) {
////                //            case BZMPopupViewAnimationSlideBottomTop:
////                //            case BZMPopupViewAnimationSlideBottomBottom:
////                //            case BZMPopupViewAnimationSlideTopTop:
////                //            case BZMPopupViewAnimationSlideTopBottom:
////                //            case BZMPopupViewAnimationSlideLeftLeft:
////                //            case BZMPopupViewAnimationSlideLeftRight:
////                //            case BZMPopupViewAnimationSlideRightLeft:
////                //            case BZMPopupViewAnimationSlideRightRight:
////                //                [self dismissPopupViewControllerWithanimationType:(BZMPopupViewAnimation)dismissButton.tag];
////                //                break;
////                //            default:
////                //                [self dismissPopupViewControllerWithanimationType:BZMPopupViewAnimationFade];
////                //                break;
////            case BZMPopupDismissAnimationTypeFadeOut:
////                break;
////            default:
////                break;
////        }
//        [self dismissPopupViewControllerWithanimation:<#(id)#>]
//    } else {
//        // [self dismissPopupViewControllerWithanimationType:BZMPopupViewAnimationFade];
//    }
}

#pragma mark animation
- (void)showViewIn:(UIView *)popupView sourceView:(UIView *)sourceView overlayView:(UIView *)overlayView animationType:(BZMPopupPresentAnimationType)animationType layout:(BZMPopupLayout)layout {
    CGSize sourceSize = sourceView.bounds.size;
    CGSize popupSize = popupView.bounds.size; // popupView.frame.size;

    CGRect containerFrame = CGRectMake((sourceSize.width - popupSize.width) / 2,
                                       (sourceSize.height - popupSize.height) / 2,
                                       popupSize.width,
                                       popupSize.height);
    
    CGRect finalContainerFrame = containerFrame;
    UIViewAutoresizing containerAutoresizingMask = UIViewAutoresizingNone;
    
    switch (layout.horizontal) {
            
        case BZMPopupLayoutHorizontalLeft: {
            finalContainerFrame.origin.x = 0.0;
            containerAutoresizingMask = containerAutoresizingMask | UIViewAutoresizingFlexibleRightMargin;
            break;
        }
            
        case BZMPopupLayoutHorizontalLeadCenter: {
            finalContainerFrame.origin.x = floorf(CGRectGetWidth(sourceView.bounds)/3.0 - CGRectGetWidth(containerFrame)/2.0);
            containerAutoresizingMask = containerAutoresizingMask | UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin;
            break;
        }
            
        case BZMPopupLayoutHorizontalCenter: {
            finalContainerFrame.origin.x = floorf((CGRectGetWidth(sourceView.bounds) - CGRectGetWidth(containerFrame))/2.0);
            containerAutoresizingMask = containerAutoresizingMask | UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin;
            break;
        }
            
        case BZMPopupLayoutHorizontalTrailCenter: {
            finalContainerFrame.origin.x = floorf(CGRectGetWidth(sourceView.bounds)*2.0/3.0 - CGRectGetWidth(containerFrame)/2.0);
            containerAutoresizingMask = containerAutoresizingMask | UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin;
            break;
        }
            
        case BZMPopupLayoutHorizontalRight: {
            finalContainerFrame.origin.x = CGRectGetWidth(sourceView.bounds) - CGRectGetWidth(containerFrame);
            containerAutoresizingMask = containerAutoresizingMask | UIViewAutoresizingFlexibleLeftMargin;
            break;
        }
            
        default:
            break;
    }
    
    // Vertical
    switch (layout.vertical) {
        case BZMPopupLayoutVerticalTop: {
            finalContainerFrame.origin.y = 0;
            containerAutoresizingMask = containerAutoresizingMask | UIViewAutoresizingFlexibleBottomMargin;
            break;
        }
            
        case BZMPopupLayoutVerticalAboveCenter: {
            finalContainerFrame.origin.y = floorf(CGRectGetHeight(sourceView.bounds)/3.0 - CGRectGetHeight(containerFrame)/2.0);
            containerAutoresizingMask = containerAutoresizingMask | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin;
            break;
        }
            
        case BZMPopupLayoutVerticalCenter: {
            finalContainerFrame.origin.y = floorf((CGRectGetHeight(sourceView.bounds) - CGRectGetHeight(containerFrame))/2.0);
            containerAutoresizingMask = containerAutoresizingMask | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin;
            break;
        }
            
        case BZMPopupLayoutVerticalBelowCenter: {
            finalContainerFrame.origin.y = floorf(CGRectGetHeight(sourceView.bounds)*2.0/3.0 - CGRectGetHeight(containerFrame)/2.0);
            containerAutoresizingMask = containerAutoresizingMask | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin;
            break;
        }
            
        case BZMPopupLayoutVerticalBottom: {
            finalContainerFrame.origin.y = CGRectGetHeight(sourceView.bounds) - CGRectGetHeight(containerFrame);
            containerAutoresizingMask = containerAutoresizingMask | UIViewAutoresizingFlexibleTopMargin;
            break;
        }
            
        default:
            break;
    }
    
    popupView.autoresizingMask = containerAutoresizingMask;
    void (^animationBlock)() = ^() {
        [self.bzm_popupViewController viewWillAppear:NO];
        self.bzm_popupBackgroundView.alpha = 0.5f;
    };
    void (^completionBlock)(BOOL) = ^(BOOL finished) {
        [self.bzm_popupViewController viewDidAppear:NO];
    };
    
//    CGFloat durationTime = self.bzm_popupDurationTime;
//    if (!durationTime) {
//        durationTime = kBZMPopupAnimationDuration;
//    }
    
    CGFloat durationTime = kBZMPopupAnimationDuration;
    
    switch (animationType) {
        case BZMPopupPresentAnimationTypeNone: {
            animationBlock();
            popupView.alpha = 1.0;
            popupView.transform = CGAffineTransformIdentity;
            popupView.frame = finalContainerFrame;
            completionBlock(YES);
            break;
        }
        case BZMPopupPresentAnimationTypeFadeIn: {
            popupView.frame = finalContainerFrame;
            popupView.alpha = 0.0f;
            [UIView animateWithDuration:durationTime animations:^{
                animationBlock();
                popupView.alpha = 1.0f;
            } completion:completionBlock];
            break;
        }
        case BZMPopupPresentAnimationTypeGrowIn: {
            popupView.alpha = 0.0;
            popupView.frame = finalContainerFrame; // set frame before transform here...
            popupView.transform = CGAffineTransformMakeScale(0.85, 0.85);
            [UIView animateWithDuration:(durationTime / 2.0) delay:0 options:kBZMPopupAnimationOptionCurveIOS7 animations:^{
                animationBlock();
                popupView.alpha = 1.0;
                popupView.transform = CGAffineTransformIdentity; // set transform before frame here...
                popupView.frame = finalContainerFrame;
            } completion:completionBlock];
            break;
        }
        case BZMPopupPresentAnimationTypeShrinkIn: {
            popupView.alpha = 0.0;
            popupView.frame = finalContainerFrame;
            popupView.transform = CGAffineTransformMakeScale(1.25, 1.25);
            [UIView animateWithDuration:(durationTime / 2.0) delay:0 options:kBZMPopupAnimationOptionCurveIOS7 animations:^{
                animationBlock();
                popupView.alpha = 1.0;
                popupView.transform = CGAffineTransformIdentity; // set transform before frame here...
                popupView.frame = finalContainerFrame;
            } completion:completionBlock];
            break;
        }
        case BZMPopupPresentAnimationTypeSlideInFromTop: {
            popupView.alpha = 1.0;
            popupView.transform = CGAffineTransformIdentity;
            
            CGRect startFrame = finalContainerFrame;
            startFrame.origin.y = -CGRectGetHeight(finalContainerFrame);
            popupView.frame = startFrame;
            

            [UIView animateWithDuration:durationTime delay:0.0f options:kBZMPopupAnimationOptionCurveIOS7 animations:^{
                animationBlock();
                popupView.frame = finalContainerFrame;
            } completion:completionBlock];
            break;
        }
        case BZMPopupPresentAnimationTypeSlideInFromBottom: {
            popupView.alpha = 1.0;
            popupView.transform = CGAffineTransformIdentity;
            
            CGRect startFrame = finalContainerFrame;
            startFrame.origin.y = CGRectGetHeight(sourceView.bounds);
            popupView.frame = startFrame;

            [UIView animateWithDuration:durationTime delay:0 options:kBZMPopupAnimationOptionCurveIOS7 animations:^{
                animationBlock();
                popupView.frame = finalContainerFrame;
            } completion:completionBlock];
            break;
        }
        case BZMPopupPresentAnimationTypeSlideInFromLeft: {
            popupView.alpha = 1.0;
            popupView.transform = CGAffineTransformIdentity;
            
            CGRect startFrame = finalContainerFrame;
            startFrame.origin.x = -CGRectGetWidth(finalContainerFrame);
            popupView.frame = startFrame;
            
            [UIView animateWithDuration:durationTime delay:0 options:kBZMPopupAnimationOptionCurveIOS7 animations:^{
                animationBlock();
                popupView.frame = finalContainerFrame;
            } completion:completionBlock];
            break;
        }
        case BZMPopupPresentAnimationTypeSlideInFromRight: {
            popupView.alpha = 1.0;
            popupView.transform = CGAffineTransformIdentity;
            
            CGRect startFrame = finalContainerFrame;
            startFrame.origin.x = CGRectGetWidth(sourceView.bounds);
            popupView.frame = startFrame;
            
            [UIView animateWithDuration:durationTime delay:0 options:kBZMPopupAnimationOptionCurveIOS7 animations:^{
                animationBlock();
                popupView.frame = finalContainerFrame;
            } completion:completionBlock];
            break;
        }
        case BZMPopupPresentAnimationTypeBounceIn: {
            popupView.alpha = 0.0;
            // set frame before transform here...
            CGRect startFrame = finalContainerFrame;
            popupView.frame = startFrame;
            popupView.transform = CGAffineTransformMakeScale(0.1, 0.1);
            
            [UIView animateWithDuration:(durationTime * 2) delay:0.0 usingSpringWithDamping:0.8 initialSpringVelocity:15.0 options:0 animations:^{
                animationBlock();
                popupView.alpha = 1.0;
                popupView.transform = CGAffineTransformIdentity;
            } completion:completionBlock];
            break;
        }
        case BZMPopupPresentAnimationTypeBounceInFromTop: {
            popupView.alpha = 1.0;
            popupView.transform = CGAffineTransformIdentity;
            
            CGRect startFrame = finalContainerFrame;
            startFrame.origin.y = -CGRectGetHeight(finalContainerFrame);
            popupView.frame = startFrame;
            
            [UIView animateWithDuration:(durationTime * 2) delay:0.0 usingSpringWithDamping:0.8 initialSpringVelocity:10.0 options:0 animations:^{
                animationBlock();
                popupView.frame = finalContainerFrame;
            } completion:completionBlock];
            break;
        }
        case BZMPopupPresentAnimationTypeBounceInFromBottom: {
            popupView.alpha = 1.0;
            popupView.transform = CGAffineTransformIdentity;
            
            CGRect startFrame = finalContainerFrame;
            startFrame.origin.y = CGRectGetHeight(sourceView.bounds);
            popupView.frame = startFrame;
            
            [UIView animateWithDuration:(durationTime * 2) delay:0.0 usingSpringWithDamping:0.8 initialSpringVelocity:10.0 options:0 animations:^{
                animationBlock();
                popupView.frame = finalContainerFrame;
            } completion:completionBlock];
            break;
        }
        case BZMPopupPresentAnimationTypeBounceInFromLeft: {
            popupView.alpha = 1.0;
            popupView.transform = CGAffineTransformIdentity;
            
            CGRect startFrame = finalContainerFrame;
            startFrame.origin.x = -CGRectGetWidth(finalContainerFrame);
            popupView.frame = startFrame;
            
            [UIView animateWithDuration:(durationTime * 2) delay:0.0 usingSpringWithDamping:0.8 initialSpringVelocity:10.0 options:0 animations:^{
                animationBlock();
                popupView.frame = finalContainerFrame;
            } completion:completionBlock];
            break;
        }
        case BZMPopupPresentAnimationTypeBounceInFromRight: {
            popupView.alpha = 1.0;
            popupView.transform = CGAffineTransformIdentity;
            
            CGRect startFrame = finalContainerFrame;
            startFrame.origin.x = CGRectGetWidth(sourceView.bounds);
            popupView.frame = startFrame;
            
            [UIView animateWithDuration:(durationTime * 2) delay:0.0 usingSpringWithDamping:0.8 initialSpringVelocity:10.0 options:0 animations:^{
                animationBlock();
                popupView.frame = finalContainerFrame;
            } completion:completionBlock];
            break;
        }
        default:
            break;
    }
}

- (void)hideViewIn:(UIView *)popupView sourceView:(UIView *)sourceView overlayView:(UIView *)overlayView animationType:(BZMPopupDismissAnimationType)animationType {
//    CGFloat durationTime = self.bzm_popupDurationTime;
//    if (!durationTime) {
//        durationTime = kBZMPopupAnimationDuration;
//    }
    
    CGFloat durationTime = kBZMPopupAnimationDuration;
    
    NSTimeInterval duration1 = (durationTime / 2.0);
    NSTimeInterval duration2 = durationTime;
    void (^animationBlock)() = ^() {
        [self.bzm_popupViewController viewWillDisappear:NO];
        self.bzm_popupBackgroundView.alpha = 0.0f;
    };
    void (^completionBlock)(BOOL) = ^(BOOL finished) {
        [popupView removeFromSuperview];
        [overlayView removeFromSuperview];
        [self.bzm_popupViewController viewDidDisappear:NO];
        self.bzm_popupViewController = nil;
        
        id dismissed = [self dismissedCallback];
        if (dismissed != nil) {
            ((void(^)(void))dismissed)();
            [self setDismissedCallback:nil];
        }
    };
    
    switch (animationType) {
        case BZMPopupDismissAnimationTypeNone: {
            animationBlock();
            popupView.alpha = 0.0f;
            completionBlock(YES);
            break;
        }
        case BZMPopupDismissAnimationTypeFadeOut: {
            [UIView animateWithDuration:duration1 delay:0 options:UIViewAnimationOptionCurveLinear animations:^{
                animationBlock();
                popupView.alpha = 0.0;
            } completion:completionBlock];
            break;
        }
        case BZMPopupDismissAnimationTypeGrowOut: {
            [UIView animateWithDuration:duration1 delay:0 options:kBZMPopupAnimationOptionCurveIOS7 animations:^{
                animationBlock();
                popupView.alpha = 0.0;
                popupView.transform = CGAffineTransformMakeScale(1.1, 1.1);
            } completion:completionBlock];
            break;
        }
        case BZMPopupDismissAnimationTypeShrinkOut: {
            [UIView animateWithDuration:duration1 delay:0 options:kBZMPopupAnimationOptionCurveIOS7 animations:^{
                animationBlock();
                popupView.alpha = 0.0;
                popupView.transform = CGAffineTransformMakeScale(0.8, 0.8);
            } completion:completionBlock];
            break;
        }
        case BZMPopupDismissAnimationTypeSlideOutToTop: {
            [UIView animateWithDuration:durationTime delay:0 options:kBZMPopupAnimationOptionCurveIOS7 animations:^{
                animationBlock();
                CGRect finalFrame = popupView.frame;
                finalFrame.origin.y = -CGRectGetHeight(finalFrame);
                popupView.frame = finalFrame;
            } completion:completionBlock];
            break;
        }
        case BZMPopupDismissAnimationTypeSlideOutToBottom: {
            [UIView animateWithDuration:durationTime delay:0 options:kBZMPopupAnimationOptionCurveIOS7 animations:^{
                animationBlock();
                CGRect finalFrame = popupView.frame;
                finalFrame.origin.y = CGRectGetHeight(sourceView.bounds);
                popupView.frame = finalFrame;
            } completion:completionBlock];
            break;
        }
        case BZMPopupDismissAnimationTypeSlideOutToLeft: {
            [UIView animateWithDuration:durationTime delay:0 options:kBZMPopupAnimationOptionCurveIOS7 animations:^{
                animationBlock();
                CGRect finalFrame = popupView.frame;
                finalFrame.origin.x = -CGRectGetWidth(finalFrame);
                popupView.frame = finalFrame;
            } completion:completionBlock];
            break;
        }
        case BZMPopupDismissAnimationTypeSlideOutToRight: {
            [UIView animateWithDuration:durationTime delay:0 options:kBZMPopupAnimationOptionCurveIOS7 animations:^{
                animationBlock();
                CGRect finalFrame = popupView.frame;
                finalFrame.origin.x = CGRectGetWidth(sourceView.bounds);
                popupView.frame = finalFrame;
            } completion:completionBlock];
            break;
        }
        case BZMPopupDismissAnimationTypeBounceOut: {
            [UIView animateWithDuration:duration1 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
                popupView.transform = CGAffineTransformMakeScale(1.1, 1.1);
            } completion:^(BOOL finished) {
                [UIView animateWithDuration:duration2 delay:0 options:UIViewAnimationOptionCurveEaseIn animations:^{
                    animationBlock();
                    popupView.alpha = 0.0;
                    popupView.transform = CGAffineTransformMakeScale(0.1, 0.1);
                } completion:completionBlock];
            }];
            break;
        }
        case BZMPopupDismissAnimationTypeBounceOutToTop: {
            [UIView animateWithDuration:duration1 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
                CGRect finalFrame = popupView.frame;
                finalFrame.origin.y += 40.0;
                popupView.frame = finalFrame;
            } completion:^(BOOL finished) {
                [UIView animateWithDuration:duration2 delay:0 options:UIViewAnimationOptionCurveEaseIn animations:^{
                    animationBlock();
                    CGRect finalFrame = popupView.frame;
                    finalFrame.origin.y = -CGRectGetHeight(finalFrame);
                    popupView.frame = finalFrame;
                } completion:completionBlock];
            }];
            break;
        }
        case BZMPopupDismissAnimationTypeBounceOutToBottom: {
            [UIView animateWithDuration:duration1 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
                CGRect finalFrame = popupView.frame;
                finalFrame.origin.y -= 40.0;
                popupView.frame = finalFrame;
            } completion:^(BOOL finished) {
                [UIView animateWithDuration:duration2 delay:0 options:UIViewAnimationOptionCurveEaseIn animations:^{
                    animationBlock();
                    CGRect finalFrame = popupView.frame;
                    finalFrame.origin.y = CGRectGetHeight(sourceView.bounds);
                    popupView.frame = finalFrame;
                } completion:completionBlock];
            }];
            break;
        }
        case BZMPopupDismissAnimationTypeBounceOutToLeft: {
            [UIView animateWithDuration:duration1 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
                CGRect finalFrame = popupView.frame;
                finalFrame.origin.x += 40.0;
                popupView.frame = finalFrame;
            } completion:^(BOOL finished) {
                [UIView animateWithDuration:duration2 delay:0 options:UIViewAnimationOptionCurveEaseIn animations:^{
                    animationBlock();
                    CGRect finalFrame = popupView.frame;
                    finalFrame.origin.x = -CGRectGetWidth(finalFrame);
                    popupView.frame = finalFrame;
                } completion:completionBlock];
            }];
            break;
        }
        case BZMPopupDismissAnimationTypeBounceOutToRight: {
            [UIView animateWithDuration:duration1 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
                CGRect finalFrame = popupView.frame;
                finalFrame.origin.x -= 40.0;
                popupView.frame = finalFrame;
            } completion:^(BOOL finished) {
                [UIView animateWithDuration:duration2 delay:0 options:UIViewAnimationOptionCurveEaseIn animations:^{
                    animationBlock();
                    CGRect finalFrame = popupView.frame;
                    finalFrame.origin.x = CGRectGetWidth(sourceView.bounds);
                    popupView.frame = finalFrame;
                } completion:completionBlock];
            }];
            break;
        }
        default:
            break;
    }
}

#pragma mark private
- (CGRect)getEndRectWithPopupView:(UIView *)popupView popupSize:(CGSize)popupSize sourceSize:(CGSize)sourceSize animationIndex:(NSInteger)animationIndex {
    CGRect endRect = CGRectZero;
    switch (animationIndex) {
        case 0:
            break;
        case 1:
            endRect = CGRectMake((sourceSize.width - popupSize.width) / 2,
                                 -popupSize.height,
                                 popupSize.width,
                                 popupSize.height);
            break;
            
        case 2:
            endRect = CGRectMake((sourceSize.width - popupSize.width) / 2,
                                 sourceSize.height,
                                 popupSize.width,
                                 popupSize.height);
            break;
            
        case 3:
            endRect = CGRectMake(-popupSize.width,
                                 popupView.frame.origin.y,
                                 popupSize.width,
                                 popupSize.height);
            break;
            
        case 4:
            endRect = CGRectMake(sourceSize.width,
                                 popupView.frame.origin.y,
                                 popupSize.width,
                                 popupSize.height);
            break;
            
        default:
            BZMLogDebug(@"不支持的动画类型！");
            break;
    }
    return endRect;
}

#pragma mark - Other
- (BZMPageViewController *)bzm_pageViewController {
    UIViewController *parentViewController = self.parentViewController;
    while (parentViewController) {
        if ([parentViewController isKindOfClass:BZMPageViewController.class]) {
            return (BZMPageViewController *)parentViewController;
        }
        parentViewController = parentViewController.parentViewController;
    }
    return nil;
}

- (BZMTabBarViewController *)bzm_tabBarViewController {
    UIViewController *parentViewController = self.parentViewController;
    while (parentViewController) {
        if ([parentViewController isKindOfClass:BZMTabBarViewController.class]) {
            return (BZMTabBarViewController *)parentViewController;
        }
        parentViewController = parentViewController.parentViewController;
    }
    return nil;
}


@end
