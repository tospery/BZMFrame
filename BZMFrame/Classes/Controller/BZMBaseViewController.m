//
//  BZMBaseViewController.m
//  AFNetworking
//
//  Created by 杨建祥 on 2019/12/30.
//

#import "BZMBaseViewController.h"
#import "BZMType.h"
#import "BZMFunction.h"
#import "BZMPageViewController.h"
#import "BZMTabBarViewController.h"
#import "UIViewController+BZMFrame.h"
#import <DKNightVersion/DKNightVersion.h>

@interface BZMBaseViewController ()
@property (nonatomic, assign, readwrite) CGFloat contentTop;
@property (nonatomic, assign, readwrite) CGFloat contentBottom;
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
    
    if (self.navigationController.viewControllers.count > 1) {
        UIImage *image = [UIImage qmui_imageWithShape:QMUIImageShapeNavBack size:CGSizeMake(10, 18) lineWidth:1.5 tintColor:BZMColorKey(BAR)];
        self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:image style:UIBarButtonItemStylePlain target:self action:@selector(backBarItemPressed:)];
    } else {
        if (self.presentingViewController) {
            UIImage *image = [UIImage qmui_imageWithShape:QMUIImageShapeNavClose size:CGSizeMake(16, 16) lineWidth:1.5 tintColor:BZMColorKey(BAR)];
            self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:image style:UIBarButtonItemStylePlain target:self action:@selector(backBarItemPressed:)];
        } else {
            self.navigationItem.leftBarButtonItem = nil;
        }
    }
    
    self.view.dk_backgroundColorPicker = DKColorPickerWithKey(BG);
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.viewModel.willDisappearSignal sendNext:nil];
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
- (CGFloat)contentTop {
    CGFloat value = BZMStatusBarHeightConstant;
    UINavigationBar *navBar = self.navigationController.navigationBar;
    if (navBar != nil && navBar.isHidden != YES) {
        value += navBar.qmui_height;
    }
    BZMPageMenuView *menuView = self.bzm_pageViewController.menuView;
    if (menuView != nil && menuView.isHidden != YES) {
        value += menuView.qmui_height;
    }
    return value;
}

- (CGFloat)contentBottom {
    CGFloat value = BZMSafeBottom;
    UITabBar *tabBar = self.tabBarController.tabBar; // self.bzm_tabBarViewController.innerTabBarController.tabBar;
    if (!self.hidesBottomBarWhenPushed && tabBar != nil && tabBar.isHidden != YES) {
        value += tabBar.qmui_height;
    }
    return value;
}

#pragma mark - Private

#pragma mark - Public
- (void)bindViewModel {
    // RAC(self.view, backgroundColor) = RACObserve(self.viewModel, backgroundColor);
    RAC(self.navigationItem, title) = RACObserve(self.viewModel, title);
    
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
    
    @weakify(self)
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
    
//    [[[RACObserve(self.viewModel, hidesNavigationBar) distinctUntilChanged] deliverOnMainThread] subscribeNext:^(NSNumber *hidesNavigationBar) {
//        @strongify(self)
//        self.navigationController.navigationBar.hidden = hidesNavigationBar.boolValue;
//    }];
//
//    [[RACObserve(self.viewModel, hidesNavBottomLine) distinctUntilChanged] subscribeNext:^(NSNumber *hidden) {
//        @strongify(self)
//        UIImage *image = hidden.boolValue ? [[UIImage alloc] init] : nil;
//        UINavigationBar *navigationBar = self.navigationController.navigationBar;
//        [navigationBar setBackgroundImage:image forBarPosition:UIBarPositionAny barMetrics:UIBarMetricsDefault];
//        navigationBar.shadowImage = image;
//    }];
}

- (void)beginLoad {
    self.viewModel.requestMode = BZMRequestModeLoad;
    if (self.viewModel.error || self.viewModel.dataSource) {
        self.viewModel.error = nil;
        self.viewModel.dataSource = nil;
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
    
}

- (void)triggerUpdate {
    //    [self beginUpdate];
    //
    //    @weakify(self)
    //    [[[self.viewModel.requestRemoteDataCommand execute:@1] deliverOnMainThread] subscribeNext:^(id  _Nullable x) {
    //
    //    } completed:^{
    //        @strongify(self)
    //        [self endUpdate];
    //    }];
}

- (void)endUpdate {
    
}

- (void)reloadData {
    
}

- (BOOL)handleError {
    return NO;
}

#pragma mark - Action
- (void)backBarItemPressed:(UIBarButtonItem *)barItem {
    [self.viewModel.backCommand execute:@(YES)];
}

- (void)closeBarItemPressed:(UIBarButtonItem *)barItem {
    [self.viewModel.backCommand execute:@(NO)];
}

#pragma mark - Notification
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
