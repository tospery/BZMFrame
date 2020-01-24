//
//  BZMTabBarViewController.m
//  Pods
//
//  Created by 杨建祥 on 2019/12/31.
//

#import "BZMTabBarViewController.h"

@interface BZMTabBarViewController ()
@property (nonatomic, strong, readwrite) UITabBarController *innerTabBarController;

@end

@implementation BZMTabBarViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.innerTabBarController = [[UITabBarController alloc] init];
    self.innerTabBarController.delegate = self;
    [self addChildViewController:self.innerTabBarController];
    [self.view addSubview:self.innerTabBarController.view];
    [self.innerTabBarController didMoveToParentViewController:self];
}

- (BOOL)shouldAutorotate {
    return self.innerTabBarController.selectedViewController.shouldAutorotate;
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations {
    return self.innerTabBarController.selectedViewController.supportedInterfaceOrientations;
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    return self.innerTabBarController.selectedViewController.preferredStatusBarStyle;
}

@end
