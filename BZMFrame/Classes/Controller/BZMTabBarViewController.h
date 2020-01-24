//
//  BZMTabBarViewController.h
//  Pods
//
//  Created by 杨建祥 on 2019/12/31.
//

#import "BZMScrollViewController.h"
#import <QMUIKit/QMUIKit.h>

@interface BZMTabBarViewController : BZMScrollViewController <UITabBarControllerDelegate>
@property (nonatomic, strong, readonly) UITabBarController *innerTabBarController;

@end

