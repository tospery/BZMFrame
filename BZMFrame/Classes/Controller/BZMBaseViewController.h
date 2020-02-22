//
//  BZMBaseViewController.h
//  AFNetworking
//
//  Created by 杨建祥 on 2019/12/30.
//

#import <QMUIKit/QMUIKit.h>
#import "BZMBaseViewModel.h"
#import "BZMNavigationBar.h"
#import "BZMEmptyView.h"

@interface BZMBaseViewController : UIViewController
@property (nonatomic, assign, readonly) CGFloat contentTop;
@property (nonatomic, assign, readonly) CGFloat contentBottom;
@property (nonatomic, assign, readonly) CGRect contentFrame;
@property (nonatomic, strong) BZMEmptyView *emptyView;
@property (nonatomic, assign, readonly, getter = isEmptyViewShowing) BOOL emptyViewShowing;
@property (nonatomic, strong, readonly) BZMNavigationBar *navigationBar;
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


- (void)showEmptyView;
- (void)showEmptyViewWithLoading;
- (void)showEmptyViewWithText:(NSString *)text
                   detailText:(NSString *)detailText
                  buttonTitle:(NSString *)buttonTitle
                 buttonAction:(SEL)action;
- (void)showEmptyViewWithImage:(UIImage *)image
                          text:(NSString *)text
                    detailText:(NSString *)detailText
                   buttonTitle:(NSString *)buttonTitle
                  buttonAction:(SEL)action;
- (void)showEmptyViewWithLoading:(BOOL)showLoading
                           image:(UIImage *)image
                            text:(NSString *)text
                      detailText:(NSString *)detailText
                     buttonTitle:(NSString *)buttonTitle
                    buttonAction:(SEL)action;
- (void)hideEmptyView;
- (BOOL)layoutEmptyView;

@end

