//
//  BZMNavigator.m
//  Pods
//
//  Created by 杨建祥 on 2020/2/22.
//

#import "BZMNavigator.h"
#import <JLRoutes/JLRoutes.h>
#import "BZMViewReactor.h"
#import "BZMViewController.h"
#import "BZMTabBarViewController.h"
#import "BZMNavigationController.h"

#define kControllerName                             (@"Controller")
#define kReactorName                                (@"Reactor")

@interface BZMNavigator () <UINavigationControllerDelegate>
//@property (nonatomic, strong, readwrite) UINavigationController *topNavigationController;
@property (nonatomic, strong) NSMutableArray *navigationControllers;

@end

@implementation BZMNavigator

#pragma mark - Property
- (UIView *)topView {
    return self.topViewController.view;
}

- (UIViewController *)topViewController {
    return self.topNavigationController.topViewController;
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

#pragma mark - Navigation
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

#pragma mark - Route
- (BOOL)routeURL:(NSURL *)url withParameters:(NSDictionary *)parameters {
    return [JLRoutes routeURL:url withParameters:parameters];
}

#pragma mark - Private
- (BZMViewController *)viewController:(BZMViewReactor *)reactor {
    NSString *name = NSStringFromClass(reactor.class);
    NSParameterAssert([name hasSuffix:kReactorName]);
    name = [name stringByReplacingCharactersInRange:NSMakeRange(name.length - kReactorName.length, kReactorName.length) withString:kControllerName];
    Class cls = NSClassFromString(name);
    NSParameterAssert([cls isSubclassOfClass:BZMViewController.class]);
    NSParameterAssert([cls instancesRespondToSelector:@selector(initWithReactor:)]);
    return [[cls alloc] initWithReactor:reactor];
}

#pragma mark - Delegate
#pragma mark BZMNavigable
- (void)resetRootReactor:(BZMViewReactor *)reactor {
    [self.navigationControllers removeAllObjects];
    UIViewController *viewController = (UIViewController *)[self viewController:reactor];
    if (![viewController isKindOfClass:[UINavigationController class]] &&
        ![viewController isKindOfClass:[UITabBarController class]] &&
        ![viewController isKindOfClass:[BZMTabBarViewController class]]) {
        viewController = [[BZMNavigationController alloc] initWithRootViewController:viewController];
        [self pushNavigationController:(UINavigationController *)viewController];
    }
    UIWindow *window = [UIApplication sharedApplication].delegate.window;
    window.rootViewController = viewController;
    [window makeKeyAndVisible];
}

- (UIViewController *)pushReactor:(BZMViewReactor *)reactor animated:(BOOL)animated {
    UIViewController *viewController = (UIViewController *)[self viewController:reactor];
    [self.topNavigationController pushViewController:viewController animated:animated];
    return viewController;
}

- (UIViewController *)presentReactor:(BZMViewReactor *)reactor animated:(BOOL)animated completion:(BZMVoidBlock)completion {
    UIViewController *viewController = (UIViewController *)[self viewController:reactor];
    UINavigationController *presentingViewController = self.topNavigationController;
    if (![viewController isKindOfClass:UINavigationController.class]) {
        viewController = [[BZMNavigationController alloc] initWithRootViewController:viewController];
    }
    [self pushNavigationController:(BZMNavigationController *)viewController];
    [presentingViewController presentViewController:viewController animated:animated completion:completion];
    return viewController;
}

- (UIViewController *)popupReactor:(BZMViewReactor *)reactor animationType:(BZMViewControllerAnimationType)animationType completion:(BZMVoidBlock)completion {
    UIViewController *viewController = (UIViewController *)[self viewController:reactor];
    [self.topNavigationController bzm_popupViewController:viewController animationType:animationType layout:BZMPopupLayoutCenter bgTouch:NO dismissed:completion];
    return viewController;
}

- (void)popReactorAnimated:(BOOL)animated completion:(BZMVoidBlock)completion {
    [CATransaction begin];
    [CATransaction setCompletionBlock:completion];
    [self.topNavigationController popViewControllerAnimated:animated];
    [CATransaction commit];
}

- (void)popToRootReactorAnimated:(BOOL)animated completion:(BZMVoidBlock)completion {
    [CATransaction begin];
    [CATransaction setCompletionBlock:completion];
    [self.topNavigationController popToRootViewControllerAnimated:animated];
    [CATransaction commit];
}

- (void)dismissReactorAnimated:(BOOL)animated completion:(BZMVoidBlock)completion {
    UINavigationController *dismissingViewController = self.topNavigationController;
    [self popNavigationController];
    [dismissingViewController dismissViewControllerAnimated:animated completion:completion];
}

- (void)closeReactorWithAnimationType:(BZMViewControllerAnimationType)animationType completion:(BZMVoidBlock)completion {
    [self.topNavigationController bzm_closeViewControllerWithAnimationType:animationType dismissed:completion];
}

@end
