//
//  UIViewController+BZMFrame.m
//  Pods
//
//  Created by 杨建祥 on 2020/1/9.
//

#import "UIViewController+BZMFrame.h"
#import "BZMPageViewController.h"
#import "BZMTabBarViewController.h"

@implementation UIViewController (BZMFrame)

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
