//
//  BZMNavigationController.m
//  Pods
//
//  Created by 杨建祥 on 2019/12/30.
//

#import "BZMNavigationController.h"
#import "BZMFunction.h"

@interface BZMNavigationController ()

@end

@implementation BZMNavigationController
- (instancetype)initWithRootViewController:(UIViewController *)rootViewController {
    if (self = [super initWithRootViewController:rootViewController]) {
        // self.navigationBar.tintColor = BZMColorKey(BAR);
        // self.navigationBar.hidden = YES;
        self.modalPresentationStyle = UIModalPresentationFullScreen;
    }
    return self;
}

@end
