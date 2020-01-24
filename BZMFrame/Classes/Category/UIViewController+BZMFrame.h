//
//  UIViewController+BZMFrame.h
//  Pods
//
//  Created by 杨建祥 on 2020/1/9.
//

#import <UIKit/UIKit.h>

@class BZMPageViewController;
@class BZMTabBarViewController;

@interface UIViewController (BZMFrame)

/**
 获取控制器所在的BZMPageViewController
 */
@property (nonatomic, strong, readonly) BZMPageViewController *bzm_pageViewController;

/**
 获取控制器所在的BZMTabBarViewController
 */
@property (nonatomic, strong, readonly) BZMTabBarViewController *bzm_tabBarViewController;

@end

