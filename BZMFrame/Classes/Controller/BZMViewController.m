//
//  BZMViewController.m
//  Pods
//
//  Created by 杨建祥 on 2020/2/22.
//

#import "BZMViewController.h"
#import <QMUIKit/QMUIKit.h>
#import <DKNightVersion/DKNightVersion.h>
#import <Toast/UIView+Toast.h>
#import "BZMType.h"
#import "BZMConstant.h"
#import "BZMFunction.h"
#import "BZMString.h"
#import "BZMAppDependency.h"
#import "BZMParameter.h"
#import "BZMViewController.h"
#import "NSDictionary+BZMFrame.h"
#import "UIViewController+BZMFrame.h"
#import "NSError+BZMFrame.h"

@interface BZMViewController ()
//@property (nonatomic, strong) UIButton *backButton;
//@property (nonatomic, strong) UIButton *closeButton;
@property (nonatomic, assign, readwrite) CGFloat contentTop;
@property (nonatomic, assign, readwrite) CGFloat contentBottom;
@property (nonatomic, assign, readwrite) CGRect contentFrame;
@property (nonatomic, strong, readwrite) BZMNavigationBar *navigationBar;
@property (nonatomic, strong, readwrite) BZMNavigator *navigator;
@property (nonatomic, strong, readwrite) BZMViewReactor *reactor;

@end

@implementation BZMViewController

#pragma mark - Init
- (instancetype)initWithReactor:(BZMViewReactor *)reactor {
    if (self = [super init]) {
        self.hidesBottomBarWhenPushed = YES;
        self.reactor = reactor;
        @weakify(self)
        [[self rac_signalForSelector:@selector(bind:)] subscribeNext:^(RACTuple *tuple) {
            @strongify(self)
//            if (self.reactor.shouldRequestRemoteData) {
//                if (!self.reactor.dataSource) {
//                    [self triggerLoad];
//                }else {
//                    [self triggerUpdate];
//                }
//            }
            // [self.reactor.loadCommand execute:nil];
            [self.reactor.load sendNext:nil];
        }];
    }
    return self;
}

#pragma mark - View
- (void)viewDidLoad {
    [super viewDidLoad];
    self.edgesForExtendedLayout = UIRectEdgeAll;
    self.extendedLayoutIncludesOpaqueBars = YES;
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    self.view.dk_backgroundColorPicker = DKColorPickerWithKey(BG);
    
    self.navigationController.navigationBar.hidden = YES;
    if (!self.reactor.hidesNavigationBar) {
        [self addNavigationBar];
        if (self.reactor.hidesNavBottomLine) {
            self.navigationBar.qmui_borderLayer.hidden = YES;
        }
    }
    
    if (self.navigationController.viewControllers.count > 1) {
        UIButton *backButton = [self.navigationBar addBackButtonToLeft];
        @weakify(self)
        [[backButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(UIControl *button) {
            @strongify(self)
            [self.navigator popReactorAnimated:YES completion:nil];
        }];
    } else {
        if (self.presentingViewController) {
            UIButton *closeButton = [self.navigationBar addCloseButtonToLeft];
            @weakify(self)
            [[closeButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(UIControl *button) {
                @strongify(self)
                [self.navigator dismissReactorAnimated:YES completion:nil];
            }];
        }
    }
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.view bringSubviewToFront:self.navigationBar];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    // [self.view bringSubviewToFront:self.navigationBar];
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    // [self.view bringSubviewToFront:self.navigationBar];
    // [self layoutEmptyView];
}

#pragma mark - Property
- (BZMNavigator *)navigator {
    if (!_navigator) {
        _navigator = BZMAppDependency.sharedInstance.navigator;
    }
    return _navigator;
}


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
    if ((navBar && !navBar.hidden) || !self.reactor.hidesNavigationBar) {
        value += BZMNavContentTopConstant;
    }
//    BZMPageMenuView *menuView = self.bzm_pageViewController.menuView;
//    if (menuView && !menuView.hidden) {
//        value += menuView.qmui_height;
//    }
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

#pragma mark - Bind
- (void)bind:(BZMViewReactor *)reactor {
    @weakify(self)
    // Action (View -> Reactor)
//    [[self rac_signalForSelector:@selector(bind:)] subscribeNext:^(RACTuple *x) {
//        // load
//    }];
    
    // State (Reactor -> View)
    RAC(self.navigationBar.titleLabel, text) = RACObserve(self.reactor, title);
    [RACObserve(self.reactor, dataSource).deliverOnMainThread subscribeNext:^(id x) {
        @strongify(self)
        [self reloadData];
    }];
    [[RACObserve(self.reactor, hidesNavigationBar) skip:1].distinctUntilChanged.deliverOnMainThread subscribeNext:^(NSNumber *hide) {
        @strongify(self)
        hide.boolValue ? [self removeNavigationBar] : [self addNavigationBar];
    }];
    [[RACObserve(self.reactor, hidesNavBottomLine) skip:1].distinctUntilChanged.deliverOnMainThread subscribeNext:^(NSNumber *hide) {
        @strongify(self)
        self.navigationBar.qmui_borderLayer.hidden = hide.boolValue;
    }];
    [[self.reactor.executing skip:1] subscribeNext:^(NSNumber *executing) {
        @strongify(self)
        if (executing.boolValue) {
            self.view.userInteractionEnabled = NO;
            [self.view makeToastActivity:CSToastPositionCenter];
        } else {
            self.view.userInteractionEnabled = YES;
            [self.view hideToastActivity];
        }
    }];
    [self.reactor.load subscribeNext:^(id x) {
        @strongify(self)
        if (self.reactor.shouldRequestRemoteData) {
            if (!self.reactor.dataSource) {
                [self triggerLoad];
            }else {
                [self triggerUpdate];
            }
        }
    }];
    [self.reactor.errors subscribeNext:^(NSError *error) {
        @strongify(self)
        [self.navigator routeURL:BZMURLWithPattern(kBZMPatternToast) withParameters:@{
            BZMParameter.message: BZMStrWithDft(error.bzm_displayMessage, kStringErrorUnknown)
        }];
    }];
    [self.reactor.navigate subscribeNext:^(id input) {
        @strongify(self)
        if ([input isKindOfClass:RACTuple.class] && [(RACTuple *)input count] == 2) {
            RACTuple *tuple = (RACTuple *)input;
            id first = tuple.first;
            id second = tuple.second;
            // 1. forward
            if ([first isKindOfClass:NSURL.class] &&
                (!second || [second isKindOfClass:NSDictionary.class])) {
                [self.navigator routeURL:first withParameters:second];
            }
            // 2. back
            else if ([first isKindOfClass:NSNumber.class]) {
                BZMViewControllerBackType type = [(NSNumber *)first integerValue];
                BZMVoidBlock completion = ^(void) {
                    @strongify(self)
                    [self.reactor.resultCommand execute:second];
                };
                if (BZMViewControllerBackTypePopOne == type) {
                    [self.navigator popReactorAnimated:YES completion:completion];
                } else if (BZMViewControllerBackTypePopAll == type) {
                    [self.navigator popToRootReactorAnimated:YES completion:completion];
                } else if (BZMViewControllerBackTypeDismiss == type) {
                    [self.navigator dismissReactorAnimated:YES completion:completion];
                } else if (BZMViewControllerBackTypeClose == type) {
                    [self.navigator closeReactorWithAnimationType:BZMViewControllerAnimationTypeFromString(self.reactor.animation) completion:completion];
                }
            }
        }
    }];
}

#pragma mark - Load
- (void)beginLoad {
    self.reactor.requestMode = BZMRequestModeLoad;
    if (self.reactor.error || self.reactor.dataSource) {
        self.reactor.error = nil;
        if (self.reactor.shouldFetchLocalData) {
            self.reactor.dataSource = [self.reactor data2Source:[self.reactor fetchLocalData]];
        } else {
            self.reactor.dataSource = nil;
        }
    }
}

- (void)triggerLoad {
    
}

- (void)endLoad {
    self.reactor.requestMode = BZMRequestModeNone;
}

#pragma mark - Update
- (void)beginUpdate {
    self.reactor.requestMode = BZMRequestModeUpdate;
    self.view.userInteractionEnabled = NO;
    [self.view makeToastActivity:CSToastPositionCenter];
}

- (void)triggerUpdate {
    [self beginUpdate];
    @weakify(self)
    [[self.reactor.requestRemoteCommand execute:nil].deliverOnMainThread subscribeNext:^(id data) {
    } completed:^{
        @strongify(self)
        [self endUpdate];
    }];
}

- (void)endUpdate {
    self.reactor.requestMode = BZMRequestModeNone;
    self.view.userInteractionEnabled = YES;
    [self.view hideToastActivity];
}

#pragma mark - Reload
- (void)reloadData {
    
}

#pragma mark - Navigation
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

#pragma mark - Delegate
#pragma mark UINavigationControllerBackButtonHandlerProtocol
- (BOOL)forceEnableInteractivePopGestureRecognizer {
    return YES;
}

#pragma mark - Class
+ (instancetype)allocWithZone:(struct _NSZone *)zone {
    BZMViewController *viewController = [super allocWithZone:zone];
    @weakify(viewController)
    [[viewController rac_signalForSelector:@selector(viewDidLoad)] subscribeNext:^(id x) {
        @strongify(viewController)
        [viewController bind:viewController.reactor];
    }];
    return viewController;
}

@end
