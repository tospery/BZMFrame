//
//  BZMTabBarViewController.h
//  Pods
//
//  Created by 杨建祥 on 2020/2/22.
//

#import "BZMScrollViewController.h"
#import "BZMTabBarViewReactor.h"

@interface BZMTabBarViewController : BZMScrollViewController <UITabBarControllerDelegate>
@property (nonatomic, strong, readonly) UITabBarController *innerTabBarController;
@property (nonatomic, strong, readonly) BZMTabBarViewReactor *reactor;

@end

