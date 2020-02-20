//
//  BZMNavigationProtocol.h
//  Pods
//
//  Created by 杨建祥 on 2020/1/3.
//

#import <UIKit/UIKit.h>
#import "BZMType.h"
#import "UIViewController+BZMFrame.h"

@class BZMBaseViewModel;

@protocol BZMNavigationProtocol <NSObject>
- (UIViewController *)resetRootViewModel:(BZMBaseViewModel *)viewModel;

- (UIViewController *)pushViewModel:(BZMBaseViewModel *)viewModel animated:(BOOL)animated;
- (UIViewController *)presentViewModel:(BZMBaseViewModel *)viewModel animated:(BOOL)animated completion:(BZMVoidBlock)completion;
- (UIViewController *)popupViewModel:(BZMBaseViewModel *)viewModel animationType:(BZMViewControllerAnimationType)animationType completion:(BZMVoidBlock)completion;

- (void)popViewModelAnimated:(BOOL)animated;
- (void)popToRootViewModelAnimated:(BOOL)animated;
- (void)dismissViewModelAnimated:(BOOL)animated completion:(BZMVoidBlock)completion;
- (void)closeViewModelWithAnimationType:(BZMViewControllerAnimationType)animationType completion:(BZMVoidBlock)completion;

@end

