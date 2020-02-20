//
//  BZMNavigator.m
//  Pods
//
//  Created by 杨建祥 on 2020/1/5.
//

#import "BZMNavigator.h"
#import <JLRoutes/JLRoutes.h>
#import "BZMConstant.h"
#import "BZMFunction.h"
#import "BZMParameter.h"
#import "BZMBaseViewController.h"
#import "BZMNavigationController.h"
#import "BZMTabBarViewController.h"
#import "UIApplication+BZMFrame.h"

@interface BZMNavigator () <UINavigationControllerDelegate>
@property (nonatomic, strong, readwrite) UINavigationController *topNavigationController;
@property (nonatomic, strong) NSMutableArray *navigationControllers;

@end

@implementation BZMNavigator

#pragma mark - Property
- (UIView *)topView {
    UIView *view = self.topNavigationController.topViewController.view;
    if (!view) {
        view = UIApplication.sharedApplication.delegate.window;
    }
    return view;
}

- (UINavigationController *)topNavigationController {
    return self.navigationControllers.lastObject;
}

- (NSMutableArray *)navigationControllers {
    if (!_navigationControllers) {
        _navigationControllers = [NSMutableArray array];
    }
    return _navigationControllers;
}

#pragma mark - Public
- (void)pushNavigationController:(UINavigationController *)navigationController {
    if ([self.navigationControllers containsObject:navigationController]) {
        return;
    }
    navigationController.delegate = self;
    [self.navigationControllers addObject:navigationController];
}

- (UINavigationController *)popNavigationController {
    UINavigationController *navigationController = self.topNavigationController;
    [self.navigationControllers removeLastObject];
    return navigationController;
}

- (BZMBaseViewController *)viewController:(BZMBaseViewModel *)viewModel {
    NSString *name = NSStringFromClass(viewModel.class);
    NSParameterAssert([name hasSuffix:kBZMVMSuffix]);
    name = [name stringByReplacingCharactersInRange:NSMakeRange(name.length - kBZMVMSuffix.length, kBZMVMSuffix.length) withString:kBZMVCSuffix];
    Class cls = NSClassFromString(name);
    NSParameterAssert([cls isSubclassOfClass:[BZMBaseViewController class]]);
    NSParameterAssert([cls instancesRespondToSelector:@selector(initWithViewModel:)]);
    return [[cls alloc] initWithViewModel:viewModel];
}

//- (BOOL)canRouteURL:(NSURL *)URL {
//    return [JLRoutes canRouteURL:URL];
//}
//
//- (BOOL)routeURL:(NSURL *)URL {
//    return [JLRoutes routeURL:URL];
//}
//
//- (BOOL)routePattern:(NSString *)pattern {
//    NSString *scheme = UIApplication.sharedApplication.bzm_urlScheme;
//    NSURL *url = BZMURLWithStr(BZMStrWithFmt(@"%@://m.%@.com%@", scheme, scheme, pattern));
//    return [self routeURL:url];
//}

- (BOOL)routeURL:(NSURL *)URL withParameters:(NSDictionary *)parameters {
    return [JLRoutes routeURL:URL withParameters:parameters];
}

//- (BOOL)routePattern:(NSString *)pattern withParameters:(NSDictionary *)parameters {
//    NSString *scheme = UIApplication.sharedApplication.bzm_urlScheme;
//    NSURL *url = BZMURLWithStr(BZMStrWithFmt(@"%@://m.%@.com%@", scheme, scheme, pattern));
//    return [JLRoutes routeURL:url withParameters:parameters];
//}

#pragma mark - Delegate
#pragma mark BZMNavigationProtocol
- (UIViewController *)resetRootViewModel:(BZMBaseViewModel *)viewModel {
    [self.navigationControllers removeAllObjects];
    UIViewController *viewController = (UIViewController *)[self viewController:viewModel];
    if (![viewController isKindOfClass:[UINavigationController class]] &&
        ![viewController isKindOfClass:[UITabBarController class]] &&
        ![viewController isKindOfClass:[BZMTabBarViewController class]]) {
        viewController = [[BZMNavigationController alloc] initWithRootViewController:viewController];
        [self pushNavigationController:(UINavigationController *)viewController];
    }
    UIWindow *window = [UIApplication sharedApplication].delegate.window;
    window.rootViewController = viewController;
    [window makeKeyAndVisible];
    return viewController;
}

- (UIViewController *)pushViewModel:(BZMBaseViewModel *)viewModel animated:(BOOL)animated {
    UIViewController *viewController = (UIViewController *)[self viewController:viewModel];
    [self.topNavigationController pushViewController:viewController animated:animated];
    return viewController;
}

- (UIViewController *)presentViewModel:(BZMBaseViewModel *)viewModel animated:(BOOL)animated completion:(BZMVoidBlock)completion {
    UIViewController *viewController = (UIViewController *)[self viewController:viewModel];
    UINavigationController *presentingViewController = self.topNavigationController;
    if (![viewController isKindOfClass:UINavigationController.class]) {
        viewController = [[BZMNavigationController alloc] initWithRootViewController:viewController];
    }
    [self pushNavigationController:(BZMNavigationController *)viewController];
    [presentingViewController presentViewController:viewController animated:animated completion:completion];
    return viewController;
}

- (UIViewController *)popupViewModel:(BZMBaseViewModel *)viewModel animationType:(BZMPopupAnimationType)animationType completion:(BZMVoidBlock)completion {
    UIViewController *viewController = (UIViewController *)[self viewController:viewModel];
    [self.topNavigationController bzm_popupViewController:viewController animationType:animationType layout:BZMPopupLayoutCenter bgTouch:NO dismissed:completion];
    return viewController;
}

- (void)popViewModelAnimated:(BOOL)animated {
    [self.topNavigationController popViewControllerAnimated:animated];
}

- (void)popToRootViewModelAnimated:(BOOL)animated {
    [self.topNavigationController popToRootViewControllerAnimated:animated];
}

- (void)dismissViewModelAnimated:(BOOL)animated completion:(BZMVoidBlock)completion {
    UINavigationController *dismissingViewController = self.topNavigationController;
    [self popNavigationController];
    [dismissingViewController dismissViewControllerAnimated:animated completion:completion];
}

- (void)closeViewModelWithAnimationType:(BZMCloseAnimationType)animationType completion:(BZMVoidBlock)completion {
    [self.topNavigationController bzm_closeViewControllerWithAnimationType:animationType dismissed:completion];
}

#pragma mark - Class
+ (instancetype)share {
    static id instance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[[self class] alloc] init];
    });
    return instance;
}

@end

