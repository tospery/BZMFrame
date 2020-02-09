//
//  BZMNavigator.h
//  Pods
//
//  Created by 杨建祥 on 2020/1/5.
//

#import <UIKit/UIKit.h>
#import "BZMNavigationProtocol.h"

@class BZMBaseViewController;

@interface BZMNavigator : NSObject <BZMNavigationProtocol>
@property (nonatomic, strong, readonly) UINavigationController *topNavigationController;

- (void)pushNavigationController:(UINavigationController *)navigationController;
- (UINavigationController *)popNavigationController;

- (BZMBaseViewController *)viewController:(BZMBaseViewModel *)viewModel;

- (BOOL)canRouteURL:(NSURL *)URL;
- (BOOL)routeURL:(NSURL *)URL;
- (BOOL)routePattern:(NSString *)pattern;

+ (instancetype)share;

@end

