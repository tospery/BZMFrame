//
//  BZMTabBarViewController.m
//  Pods
//
//  Created by 杨建祥 on 2020/2/22.
//

#import "BZMTabBarViewController.h"

@interface BZMTabBarViewController ()
@property (nonatomic, strong, readwrite) UITabBarController *innerTabBarController;
@property (nonatomic, strong, readwrite) BZMTabBarViewReactor *reactor;

@end

@implementation BZMTabBarViewController
@dynamic reactor;

#pragma mark - Init
- (instancetype)initWithReactor:(BZMViewReactor *)reactor {
    if (self = [super initWithReactor:reactor]) {
    }
    return self;
}

#pragma mark - View
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.innerTabBarController = [[UITabBarController alloc] init];
    self.innerTabBarController.delegate = self;
    [self addChildViewController:self.innerTabBarController];
    [self.view addSubview:self.innerTabBarController.view];
    [self.innerTabBarController didMoveToParentViewController:self];
}

#pragma mark - Bind
- (void)bind:(BZMBaseReactor *)reactor {
    [super bind:reactor];
    // Bind
    @weakify(self)
    [[self rac_signalForSelector:@selector(tabBarController:didSelectViewController:) fromProtocol:@protocol(UITabBarControllerDelegate)] subscribeNext:^(RACTuple *tuple) {
        @strongify(self)
        [self.navigator popNavigationController];
        [self.navigator pushNavigationController:tuple.second];
    }];
}

#pragma mark - Orientation
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
