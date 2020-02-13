//
//  BZMBaseViewController.h
//  AFNetworking
//
//  Created by 杨建祥 on 2019/12/30.
//

#import <QMUIKit/QMUIKit.h>
#import "BZMBaseViewModel.h"

@interface BZMBaseViewController : UIViewController
@property (nonatomic, assign, readonly) CGFloat contentTop;
@property (nonatomic, assign, readonly) CGFloat contentBottom;
@property (nonatomic, assign, readonly) CGRect contentFrame;
@property (nonatomic, strong, readonly) BZMBaseViewModel *viewModel;

- (instancetype)initWithCoder:(NSCoder *)aDecoder NS_UNAVAILABLE;
- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil NS_UNAVAILABLE;
- (instancetype)initWithViewModel:(BZMBaseViewModel *)viewModel;


- (void)addNavigationBar;
- (void)removeNavigationBar;

- (void)bindViewModel;

- (void)reloadData;
- (BOOL)handleError;

- (void)beginLoad;
- (void)triggerLoad;
- (void)endLoad;

- (void)beginUpdate;
- (void)triggerUpdate;
- (void)endUpdate;

@end

