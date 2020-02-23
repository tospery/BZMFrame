//
//  UIViewController+BZMFrame.h
//  Pods
//
//  Created by 杨建祥 on 2020/2/23.
//

#import <UIKit/UIKit.h>

@class BZMPopupBackgroundView;

typedef NS_ENUM(NSInteger, BZMViewControllerAnimationType){
    BZMViewControllerAnimationTypeNone,
    BZMViewControllerAnimationTypeFade,
    BZMViewControllerAnimationTypeGrow,
    BZMViewControllerAnimationTypeShrink,
    BZMViewControllerAnimationTypeBounce
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

- (void)bzm_popupViewController:(UIViewController *)popupViewController animationType:(BZMViewControllerAnimationType)animationType layout:(BZMPopupLayout)layout bgTouch:(BOOL)bgTouch dismissed:(void(^)(void))dismissed;
- (void)bzm_closeViewControllerWithAnimationType:(BZMViewControllerAnimationType)animationType;
- (void)bzm_closeViewControllerWithAnimationType:(BZMViewControllerAnimationType)animationType dismissed:(void(^)(void))dismissed;

@end

BZMViewControllerAnimationType BZMViewControllerAnimationTypeFromString(NSString *value);
