//
//  BZMPageViewController.h
//  Pods
//
//  Created by 杨建祥 on 2020/1/9.
//

#import "BZMScrollViewController.h"
#import "BZMPageViewModel.h"
#import "BZMPageMenuView.h"

@interface BZMPageViewController : BZMScrollViewController <BZMPageMenuViewDelegate>
@property (nonatomic, strong, readonly) BZMPageMenuView *menuView;
@property (nonatomic, strong, readonly) BZMPageContainerView *containerView;

- (BZMPageMenuView *)preferredMenuView;
- (BZMPageContainerView *)preferredContainerView;

@end

