//
//  BZMNavigable.h
//  Pods
//
//  Created by 杨建祥 on 2020/2/22.
//

#import <UIKit/UIKit.h>
#import "BZMType.h"
#import "UIViewController+BZMFrame.h"

@class BZMViewReactor;

@protocol BZMNavigable <NSObject>

- (void)resetRootReactor:(BZMViewReactor *)reactor;

- (UIViewController *)pushReactor:(BZMViewReactor *)viewModel animated:(BOOL)animated;
- (UIViewController *)presentReactor:(BZMViewReactor *)viewModel animated:(BOOL)animated completion:(BZMVoidBlock)completion;
- (UIViewController *)popupReactor:(BZMViewReactor *)viewModel animationType:(BZMViewControllerAnimationType)animationType completion:(BZMVoidBlock)completion;

//- (void)popReactorAnimated:(BOOL)animated completion:(BZMVoidBlock)completion;
//- (void)popToRootReactorAnimated:(BOOL)animated completion:(BZMVoidBlock)completion;
//- (void)dismissReactorAnimated:(BOOL)animated completion:(BZMVoidBlock)completion;
//- (void)closeReactorWithAnimationType:(BZMViewControllerAnimationType)animationType completion:(BZMVoidBlock)completion;

@end

