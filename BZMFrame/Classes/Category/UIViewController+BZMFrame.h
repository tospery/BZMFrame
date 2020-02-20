//
//  UIViewController+BZMFrame.h
//  Pods
//
//  Created by 杨建祥 on 2020/1/9.
//

#import <UIKit/UIKit.h>

@class BZMPopupBackgroundView;
@class BZMPageViewController;
@class BZMTabBarViewController;

typedef NS_ENUM(NSInteger, BZMPopupAnimationType){
    BZMPopupAnimationTypeNone,
    BZMPopupAnimationTypeFadeIn,
    BZMPopupAnimationTypeGrowIn,
    BZMPopupAnimationTypeShrinkIn,
    BZMPopupAnimationTypeSlideInFromTop,
    BZMPopupAnimationTypeSlideInFromBottom,
    BZMPopupAnimationTypeSlideInFromLeft,
    BZMPopupAnimationTypeSlideInFromRight,
    BZMPopupAnimationTypeBounceIn,
    BZMPopupAnimationTypeBounceInFromTop,
    BZMPopupAnimationTypeBounceInFromBottom,
    BZMPopupAnimationTypeBounceInFromLeft,
    BZMPopupAnimationTypeBounceInFromRight
};

typedef NS_ENUM(NSInteger, BZMCloseAnimationType){
    BZMCloseAnimationTypeNone,
    BZMCloseAnimationTypeFadeOut,
    BZMCloseAnimationTypeGrowOut,
    BZMCloseAnimationTypeShrinkOut,
    BZMCloseAnimationTypeSlideOutToTop,
    BZMCloseAnimationTypeSlideOutToBottom,
    BZMCloseAnimationTypeSlideOutToLeft,
    BZMCloseAnimationTypeSlideOutToRight,
    BZMCloseAnimationTypeBounceOut,
    BZMCloseAnimationTypeBounceOutToTop,
    BZMCloseAnimationTypeBounceOutToBottom,
    BZMCloseAnimationTypeBounceOutToLeft,
    BZMCloseAnimationTypeBounceOutToRight,
};

typedef NS_ENUM(NSInteger, BZMPopupLayoutHorizontal) {
    BZMPopupLayoutHorizontalCustom = 0,
    BZMPopupLayoutHorizontalLeft,
    BZMPopupLayoutHorizontalLeadCenter,
    BZMPopupLayoutHorizontalCenter,
    BZMPopupLayoutHorizontalTrailCenter,
    BZMPopupLayoutHorizontalRight,
};

typedef NS_ENUM(NSInteger, BZMPopupLayoutVertical) {
    BZMPopupLayoutVerticalCustom = 0,
    BZMPopupLayoutVerticalTop,
    BZMPopupLayoutVerticalAboveCenter,
    BZMPopupLayoutVerticalCenter,
    BZMPopupLayoutVerticalBelowCenter,
    BZMPopupLayoutVerticalBottom,
};

struct BZMPopupLayout {
    BZMPopupLayoutHorizontal horizontal;
    BZMPopupLayoutVertical vertical;
};
typedef struct BZMPopupLayout BZMPopupLayout;

extern BZMPopupLayout BZMPopupLayoutMake(BZMPopupLayoutHorizontal horizontal, BZMPopupLayoutVertical vertical);
extern const BZMPopupLayout BZMPopupLayoutCenter;

@interface UIViewController (BZMFrame)
@property (nonatomic, retain) UIViewController *bzm_popupViewController;
@property (nonatomic, retain) BZMPopupBackgroundView *bzm_popupBackgroundView;

- (void)bzm_popupViewController:(UIViewController *)popupViewController animationType:(BZMPopupAnimationType)animationType layout:(BZMPopupLayout)layout bgTouch:(BOOL)bgTouch dismissed:(void(^)(void))dismissed;
- (void)bzm_closeViewControllerWithAnimationType:(BZMCloseAnimationType)animationType;
- (void)bzm_closeViewControllerWithAnimationType:(BZMCloseAnimationType)animationType dismissed:(void(^)(void))dismissed;

/**
 获取控制器所在的BZMPageViewController
 */
@property (nonatomic, strong, readonly) BZMPageViewController *bzm_pageViewController;

/**
 获取控制器所在的BZMTabBarViewController
 */
@property (nonatomic, strong, readonly) BZMTabBarViewController *bzm_tabBarViewController;

@end

