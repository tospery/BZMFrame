//
//  BZMNavigator.m
//  Pods
//
//  Created by 杨建祥 on 2020/2/22.
//

#import "BZMNavigator.h"
#import "BZMViewReactor.h"
#import "BZMViewController.h"
#import "BZMTabBarViewController.h"
#import "BZMNavigationController.h"

#define kControllerName                             (@"Controller")
#define kReactorName                                (@"Reactor")

@interface BZMNavigator () <UINavigationControllerDelegate>
@property (nonatomic, strong, readwrite) UINavigationController *topNavigationController;
@property (nonatomic, strong) NSMutableArray *navigationControllers;

@end

@implementation BZMNavigator

#pragma mark - Init
#pragma mark - View
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

@end
