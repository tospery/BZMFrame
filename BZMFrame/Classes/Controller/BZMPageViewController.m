//
//  BZMPageViewController.m
//  Pods
//
//  Created by 杨建祥 on 2020/1/9.
//

#import "BZMPageViewController.h"
#import "BZMFunction.h"
#import "BZMPageViewModel.h"
#import "BZMPageMenuTitleView.h"
#import "BZMPageMenuIndicatorLineView.h"

@interface BZMPageViewController ()
@property (nonatomic, strong, readwrite) BZMPageViewModel *viewModel;
@property (nonatomic, strong, readwrite) BZMPageMenuView *menuView;
@property (nonatomic, strong, readwrite) BZMPageContainerView *containerView;

@end

@implementation BZMPageViewController
@dynamic viewModel;

#pragma mark - Init
- (instancetype)initWithViewModel:(BZMPageViewModel *)viewModel {
    if (self = [super initWithViewModel:viewModel]) {
    }
    return self;
}

#pragma mark - View
- (void)viewDidLoad {
    [super viewDidLoad];
    self.containerView = [self preferredContainerView];
    [self.view addSubview:self.containerView];
    
    self.menuView = [self preferredMenuView];
    self.menuView.containerView = self.containerView;
    self.menuView.delegate = self;
    [self.view addSubview:self.menuView];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    // self.navigationController.interactivePopGestureRecognizer.enabled = (self.menuView.selectedIndex == 0);
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    // self.navigationController.interactivePopGestureRecognizer.enabled = YES;
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    self.menuView.frame = CGRectMake(0, self.contentTop, self.view.qmui_width, self.menuView.qmui_height);
    self.containerView.frame = CGRectMake(0, self.menuView.qmui_bottom, self.view.qmui_width, self.view.qmui_height - self.menuView.qmui_bottom - self.contentBottom);
}

#pragma mark - Method
#pragma mark super
- (BOOL)forceEnableInteractivePopGestureRecognizer {
    return (self.menuView.selectedIndex == 0);
}

- (void)bindViewModel {
    [super bindViewModel];
    if ([self.menuView isKindOfClass:BZMPageMenuTitleView.class]) {
        BZMPageMenuTitleView *menuView = (BZMPageMenuTitleView *)self.menuView;
        RAC(menuView, titles) = RACObserve(self.viewModel, dataSource);
    }
}

#pragma mark public
- (BZMPageMenuView *)preferredMenuView {
    BZMPageMenuTitleView *menuView = [[BZMPageMenuTitleView alloc] initWithFrame:CGRectMake(0, 0, self.view.qmui_width, BZMMetric(40))];
    menuView.titleColorGradientEnabled = YES;
    BZMPageMenuIndicatorLineView *lineView = [[BZMPageMenuIndicatorLineView alloc] init];
    lineView.indicatorWidth = BZMPageAutomaticDimension;
    menuView.indicators = @[lineView];
    return menuView;
}

- (BZMPageContainerView *)preferredContainerView {
    return [[BZMPageContainerView alloc] initWithType:BZMPageContainerTypeScrollView dataSource:self.viewModel];
}

#pragma mark - Delegate
#pragma mark BZMPageViewModelDelegate
- (void)reloadData {
    [super reloadData];
    [self.menuView reloadData];
}

#pragma mark BZMPageMenuViewDelegate
- (void)menuView:(BZMPageMenuView *)menuView didSelectedItemAtIndex:(NSInteger)index {
    
}

- (void)menuView:(BZMPageMenuView *)menuView didScrollSelectedItemAtIndex:(NSInteger)index {
    
}

@end
