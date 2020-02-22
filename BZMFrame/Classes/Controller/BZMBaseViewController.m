//
//  BZMBaseViewController.m
//  AFNetworking
//
//  Created by 杨建祥 on 2019/12/30.
//

#import "BZMBaseViewController.h"
#import <Toast/UIView+Toast.h>
#import <DKNightVersion/DKNightVersion.h>
#import "BZMType.h"
#import "BZMFunction.h"
#import "BZMPageViewController.h"
#import "BZMTabBarViewController.h"
#import "UIViewController+BZMFrame.h"

@interface BZMBaseViewController ()
@property (nonatomic, assign, readwrite) CGFloat contentTop;
@property (nonatomic, assign, readwrite) CGFloat contentBottom;
@property (nonatomic, assign, readwrite) CGRect contentFrame;
@property (nonatomic, strong, readwrite) BZMNavigationBar *navigationBar;
@property (nonatomic, strong, readwrite) BZMBaseViewModel *viewModel;

@end

@implementation BZMBaseViewController
#pragma mark - Init
- (instancetype)initWithViewModel:(BZMBaseViewModel *)viewModel {
    if (self = [super init]) {
        self.hidesBottomBarWhenPushed = YES;
        self.viewModel = viewModel;
        self.viewModel.viewController = self;
        @weakify(self)
        [[self rac_signalForSelector:@selector(bindViewModel)] subscribeNext:^(RACTuple *tuple) {
            @strongify(self)
            if (viewModel.shouldRequestRemoteData) {
                if (!viewModel.dataSource) {
                    [self triggerLoad];
                }else {
                    [self triggerUpdate];
                }
            }
        }];
    }
    return self;
}

- (void)dealloc {
    BZMRemoveObserver(self);
}

#pragma mark - View
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.edgesForExtendedLayout = UIRectEdgeAll;
    self.extendedLayoutIncludesOpaqueBars = YES;
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    self.view.dk_backgroundColorPicker = DKColorPickerWithKey(BG);
    
    self.navigationController.navigationBar.hidden = YES;
    if (!self.viewModel.hidesNavigationBar) {
        [self addNavigationBar];
        if (self.viewModel.hidesNavBottomLine) {
            self.navigationBar.qmui_borderLayer.hidden = YES;
        }
    }
    if (self.navigationController.viewControllers.count > 1) {
        UIButton *backButton = [self.navigationBar addBackButtonToLeft];
        @weakify(self)
        [[backButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl *x) {
            @strongify(self)
            [self.viewModel.backCommand execute:@(BZMViewControllerBackTypePopOne)];
        }];
    } else {
        if (self.presentingViewController) {
            UIButton *closeButton = [self.navigationBar addCloseButtonToLeft];
            @weakify(self)
            [[closeButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl *x) {
                @strongify(self)
                [self.viewModel.backCommand execute:@(BZMViewControllerBackTypeDismiss)];
            }];
        }
    }
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.viewModel.willDisappearSignal sendNext:nil];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.view bringSubviewToFront:self.navigationBar];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self.view bringSubviewToFront:self.navigationBar];
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    [self.view bringSubviewToFront:self.navigationBar];
    [self layoutEmptyView];
}

#pragma mark - Super
- (void)didMoveToParentViewController:(UIViewController *)parent {
    [super didMoveToParentViewController:parent];
//    if (!parent) {
//        NSString *pageMD5 = [self.viewModel.params tb_stringForKey:kTBParamForwardPageMD5];
//        if (pageMD5.length != 0) {
//            TBNotify(kTBViewControllerDidBackNotification, self.viewModel.params, nil);
//        }
//    }
}

#pragma mark - Property
- (BZMNavigationBar *)navigationBar {
    if (!_navigationBar) {
        BZMNavigationBar *navigationBar = [[BZMNavigationBar alloc] init];
        navigationBar.layer.zPosition = FLT_MAX;
        [navigationBar sizeToFit];
        _navigationBar = navigationBar;
    }
    return _navigationBar;
}

- (CGFloat)contentTop {
    CGFloat value = 0;
    UINavigationBar *navBar = self.navigationController.navigationBar;
    if ((navBar && !navBar.hidden) || !self.viewModel.hidesNavigationBar) {
        value += BZMNavContentTopConstant;
    }
    BZMPageMenuView *menuView = self.bzm_pageViewController.menuView;
    if (menuView && !menuView.hidden) {
        value += menuView.qmui_height;
    }
    return value;
}

- (CGFloat)contentBottom {
    CGFloat value = BZMSafeBottom;
    UITabBar *tabBar = self.tabBarController.tabBar; // self.bzm_tabBarViewController.innerTabBarController.tabBar;
    if (tabBar && !tabBar.hidden && !self.hidesBottomBarWhenPushed) {
        value += tabBar.qmui_height;
    }
    return value;
}

- (CGRect)contentFrame {
    return CGRectMake(0, self.contentTop, self.view.qmui_width, self.view.qmui_height - self.contentTop - self.contentBottom);
}

#pragma mark - Private

#pragma mark - Public
- (void)bindViewModel {
    RAC(self.navigationBar.titleLabel, text) = RACObserve(self.viewModel, title);
    
    @weakify(self)
    [[RACObserve(self.viewModel, hidesNavigationBar) skip:1].distinctUntilChanged.deliverOnMainThread subscribeNext:^(NSNumber *hide) {
        @strongify(self)
        hide.boolValue ? [self removeNavigationBar] : [self addNavigationBar];
    }];
    [[RACObserve(self.viewModel, hidesNavBottomLine) skip:1].distinctUntilChanged.deliverOnMainThread subscribeNext:^(NSNumber *hide) {
        @strongify(self)
        self.navigationBar.qmui_borderLayer.hidden = hide.boolValue;
    }];
    
    //    // Double title view
    //    TBDoubleTitleView *doubleTitleView = [[TBDoubleTitleView alloc] init];
    //    RAC(doubleTitleView.titleLabel, text)    = RACObserve(self.viewModel, title);
    //    RAC(doubleTitleView.subtitleLabel, text) = RACObserve(self.viewModel, subtitle);
    //
    //    // Loading title view
    //    NSBundle *bundle = [NSBundle tb_bundleWithModule:kTBModuleFrame];
    //    TBLoadingTitleView *loadingTitleView = [bundle loadNibNamed:@"TBLoadingTitleView" owner:nil options:nil].firstObject;
    //    loadingTitleView.frame = CGRectMake((TBScreenWidth() - CGRectGetWidth(loadingTitleView.frame)) / 2.0, 0, CGRectGetWidth(loadingTitleView.frame), CGRectGetHeight(loadingTitleView.frame));
    //
    //    UIView *titleView = self.navigationItem.titleView;
    //    RAC(self.navigationItem, titleView) = [RACObserve(self.viewModel, titleViewType).distinctUntilChanged map:^(NSNumber *value) {
    //        TBTitleViewType titleViewType = value.unsignedIntegerValue;
    //        switch (titleViewType) {
    //            case TBTitleViewTypeDefault:
    //                return titleView;
    //            case TBTitleViewTypeDoubleTitle:
    //                return (UIView *)doubleTitleView;
    //            case TBTitleViewTypeLoadingTitle:
    //                return (UIView *)loadingTitleView;
    //        }
    //    }];
    
    [RACObserve(self.viewModel, dataSource).deliverOnMainThread subscribeNext:^(id x) {
        @strongify(self)
        [self reloadData];
    }];
    
    //    [[[RACObserve(self.navigationBar, hidden) skip:1] distinctUntilChanged] subscribeNext:^(id x) {
    //       @strongify(self)
    //        self.viewDisplayFrame = CGRectZero;
    //    }];
    
    [self.viewModel.errors subscribeNext:^(NSError *error) {
//        @strongify(self)
//        TBLogError(@"发送错误：%@", error);
//        if (error.code == TBErrorCodeAppLoginExpired) {
//            UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Expired"
//                                                                                     message:@"Your authorization has expired, please login again"
//                                                                              preferredStyle:UIAlertControllerStyleAlert];
//            //@weakify(self)
//            [alertController addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
//                //@strongify(self)
//                //                TBLoginVM *loginVM = [[TBLoginVM alloc] initWithServices:self.viewModel.services params:nil];
//                //                [self.viewModel.services resetRootViewModel:loginVM];
//                TBLoginVM *loginVM = [[TBLoginVM alloc] initWithParams:nil];
//                [[TBForwardManager sharedInstance] resetRootViewModel:loginVM];
//            }]];
//
//            [self presentViewController:alertController animated:YES completion:NULL];
//        }
    }];
}

- (void)beginLoad {
    self.viewModel.requestMode = BZMRequestModeLoad;
    if (self.viewModel.error || self.viewModel.dataSource) {
        self.viewModel.error = nil;
        if (self.viewModel.shouldFetchLocalData) {
            self.viewModel.dataSource = [self.viewModel data2Source:[self.viewModel fetchLocalData]];
        } else {
            self.viewModel.dataSource = nil;
        }
    }
}

- (void)triggerLoad {
    //    if (!self.triggerLoadToken) {
    //        self.triggerLoadToken = YES;
    //    }else {
    //        self.viewModel.error = nil;
    //        self.viewModel.dataSource = nil;
    //    }
    //
    //    [self.viewModel.requestRemoteDataCommand execute:@1];
}

- (void)endLoad {
    self.viewModel.requestMode = BZMRequestModeNone;
}

- (void)beginUpdate {
    self.viewModel.requestMode = BZMRequestModeUpdate;
//    if (self.viewModel.error || self.viewModel.dataSource) {
//        self.viewModel.error = nil;
//        self.viewModel.dataSource = nil;
//    }
    self.view.userInteractionEnabled = NO;
    [self.view makeToastActivity:CSToastPositionCenter];
}

- (void)triggerUpdate {
    [self beginUpdate];
    @weakify(self)
    [[self.viewModel.requestRemoteDataCommand execute:nil].deliverOnMainThread subscribeNext:^(id data) {
    } completed:^{
        @strongify(self)
        [self endUpdate];
    }];
}

- (void)endUpdate {
    self.viewModel.requestMode = BZMRequestModeNone;
    self.view.userInteractionEnabled = YES;
    [self.view hideToastActivity];
}

- (void)reloadData {
    
}

- (BOOL)handleError {
    return NO;
}

- (void)addNavigationBar {
    if (!self.navigationBar.superview) {
        [self.view addSubview:self.navigationBar];
    }
}

- (void)removeNavigationBar {
    if (self.navigationBar.superview) {
        [self.navigationBar removeFromSuperview];
    }
}

#pragma mark - Public
#pragma mark empty
- (BZMEmptyView *)emptyView {
    if (!_emptyView && self.isViewLoaded) {
        _emptyView = [[BZMEmptyView alloc] initWithFrame:self.view.bounds];
        _emptyView.dk_backgroundColorPicker = DKColorPickerWithKey(BG);
    }
    return _emptyView;
}

- (void)showEmptyView {
    [self.view addSubview:self.emptyView];
}

- (void)hideEmptyView {
    [_emptyView removeFromSuperview];
}

- (BOOL)isEmptyViewShowing {
    return _emptyView && _emptyView.superview;
}

- (void)showEmptyViewWithLoading {
    [self showEmptyView];
    [self.emptyView setImage:nil];
    [self.emptyView setLoadingViewHidden:NO];
    [self.emptyView setTextLabelText:nil];
    [self.emptyView setDetailTextLabelText:nil];
    [self.emptyView setActionButtonTitle:nil];
}

- (void)showEmptyViewWithText:(NSString *)text
                   detailText:(NSString *)detailText
                  buttonTitle:(NSString *)buttonTitle
                 buttonAction:(SEL)action {
    [self showEmptyViewWithLoading:NO image:nil text:text detailText:detailText buttonTitle:buttonTitle buttonAction:action];
}

- (void)showEmptyViewWithImage:(UIImage *)image
                          text:(NSString *)text
                    detailText:(NSString *)detailText
                   buttonTitle:(NSString *)buttonTitle
                  buttonAction:(SEL)action {
    [self showEmptyViewWithLoading:NO image:image text:text detailText:detailText buttonTitle:buttonTitle buttonAction:action];
}

- (void)showEmptyViewWithLoading:(BOOL)showLoading
                           image:(UIImage *)image
                            text:(NSString *)text
                      detailText:(NSString *)detailText
                     buttonTitle:(NSString *)buttonTitle
                    buttonAction:(SEL)action {
    [self showEmptyView];
    [self.emptyView setLoadingViewHidden:!showLoading];
    [self.emptyView setImage:image];
    [self.emptyView setTextLabelText:text];
    [self.emptyView setDetailTextLabelText:detailText];
    [self.emptyView setActionButtonTitle:buttonTitle];
    [self.emptyView.actionButton removeTarget:nil action:NULL forControlEvents:UIControlEventAllEvents];
    [self.emptyView.actionButton addTarget:self action:action forControlEvents:UIControlEventTouchUpInside];
}

- (BOOL)layoutEmptyView {
    if (_emptyView) {
        BOOL viewDidLoad = self.emptyView.superview && [self isViewLoaded];
        if (viewDidLoad) {
            CGSize newEmptyViewSize = self.emptyView.superview.bounds.size;
            CGSize oldEmptyViewSize = self.emptyView.frame.size;
            if (!CGSizeEqualToSize(newEmptyViewSize, oldEmptyViewSize)) {
                self.emptyView.qmui_frameApplyTransform = CGRectFlatMake(CGRectGetMinX(self.emptyView.frame), CGRectGetMinY(self.emptyView.frame), newEmptyViewSize.width, newEmptyViewSize.height);
            }
            return YES;
        }
    }
    return NO;
}

#pragma mark - Delegate
#pragma mark UINavigationControllerBackButtonHandlerProtocol
- (BOOL)forceEnableInteractivePopGestureRecognizer {
    return YES;
}

#pragma mark - Class
+ (instancetype)allocWithZone:(struct _NSZone *)zone {
    BZMBaseViewController *viewController = [super allocWithZone:zone];
    @weakify(viewController)
    [[viewController rac_signalForSelector:@selector(viewDidLoad)] subscribeNext:^(id x) {
        @strongify(viewController)
        [viewController bindViewModel];
    }];
    
    return viewController;
}

@end
