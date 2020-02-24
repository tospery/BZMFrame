//
//  BZMNavigator.h
//  Pods
//
//  Created by 杨建祥 on 2020/2/22.
//

#import <UIKit/UIKit.h>
#import "BZMNavigable.h"

@class BZMViewController;

@interface BZMNavigator : NSObject <BZMNavigable>
@property (nonatomic, strong, readonly) UIView *topView;
@property (nonatomic, strong, readonly) UIViewController *topViewController;
@property (nonatomic, strong, readonly) UINavigationController *topNavigationController;

- (void)pushNavigationController:(UINavigationController *)navigationController;
- (UINavigationController *)popNavigationController;

- (BOOL)routeURL:(NSURL *)url withParameters:(NSDictionary *)parameters;

@end

