//
//  BZMViewController.m
//  Pods
//
//  Created by 杨建祥 on 2020/2/22.
//

#import "BZMViewController.h"
#import <DKNightVersion/DKNightVersion.h>

@interface BZMViewController ()
@property (nonatomic, strong, readwrite) BZMViewReactor *reactor;

@end

@implementation BZMViewController

#pragma mark - Init
- (instancetype)initWithReactor:(BZMViewReactor *)reactor {
    if (self = [super init]) {
        self.hidesBottomBarWhenPushed = YES;
        self.reactor = reactor;
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
}

#pragma mark - Property
#pragma mark - Bind
- (void)bind:(BZMViewReactor *)reactor {
    // action (View -> Reactor)
    
    // state (Reactor -> View)
    RAC(self.navigationItem, title) = RACObserve(self.reactor, title);
}

#pragma mark - Delegate
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
