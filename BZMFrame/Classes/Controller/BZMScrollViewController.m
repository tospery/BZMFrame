//
//  BZMScrollViewController.m
//  Pods
//
//  Created by 杨建祥 on 2019/12/30.
//

#import "BZMScrollViewController.h"
#import <MJRefresh/MJRefresh.h>
#import "BZMFunction.h"
#import "BZMTableViewController.h"
#import "BZMCollectionViewController.h"
#import "BZMTabBarViewController.h"
#import "BZMPageViewController.h"
#import "BZMWebViewController.h"
#import "UIScrollView+BZMFrame.h"

@interface BZMScrollViewController ()
@property (nonatomic, strong, readwrite) BZMScrollViewModel *viewModel;

@end

@implementation BZMScrollViewController
@dynamic viewModel;

#pragma mark - Init
- (instancetype)initWithViewModel:(BZMBaseViewModel *)viewModel {
    if (self = [super initWithViewModel:viewModel]) {
    }
    return self;
}

- (void)dealloc {
    _scrollView.delegate = nil;
    _scrollView.emptyDataSetSource = nil;
    _scrollView.emptyDataSetDelegate = nil;
    _scrollView = nil;
}

#pragma mark - View
- (void)viewDidLoad {
    [super viewDidLoad];
    if (![self isKindOfClass:BZMTableViewController.class] &&
        ![self isKindOfClass:BZMCollectionViewController.class] &&
        ![self isKindOfClass:BZMWebViewController.class]) {
        UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, self.contentTop, self.view.qmui_width, self.view.qmui_height - self.contentTop - self.contentBottom)];
        scrollView.bzm_contentView = [[UIView alloc] init];
        scrollView.bzm_contentView.dk_backgroundColorPicker = DKColorPickerWithKey(BG);
        scrollView.contentSize = CGSizeMake(scrollView.qmui_width, scrollView.qmui_height + PixelOne);
        scrollView.dk_backgroundColorPicker = DKColorPickerWithKey(BG);
        scrollView.delegate = self;
        scrollView.emptyDataSetSource = self.viewModel;
        scrollView.emptyDataSetDelegate = self;
        if (@available(iOS 11.0, *)) {
            scrollView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        }
        [self.view addSubview:scrollView];
        self.scrollView = scrollView;
    }
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    // self.scrollView.frame = CGRectMake(self.contentTop, 0, self.view.qmui_width, self.view.qmui_height - self.contentTop - self.contentBottom + PixelOne);
}

#pragma mark - Property
//- (void)setScrollView:(UIScrollView *)scrollView {
//    _scrollView = scrollView;
//    _scrollView.emptyDataSetSource = self.viewModel;
//    _scrollView.emptyDataSetDelegate = self;
//    if (@available(iOS 11.0, *)) {
//        _scrollView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
//    }
//}

#pragma mark - Method
#pragma mark super
- (void)beginLoad {
    [super beginLoad];
    [self setupRefresh:NO];
    [self setupMore:NO];
}

- (void)triggerLoad {
    [self beginLoad];
    @weakify(self)
    [[self.viewModel.requestRemoteDataCommand execute:@(self.viewModel.page.start)].deliverOnMainThread subscribeNext:^(id data) {
        @strongify(self)
        self.viewModel.page.index = self.viewModel.page.start;
    } completed:^{
        @strongify(self)
        [self endLoad];
    }];
}

- (void)endLoad {
    [super endLoad];
    if (self.viewModel.shouldPullToRefresh) {
        [self setupRefresh:YES];
    }
    if (self.viewModel.shouldScrollToMore) {
        [self setupMore:YES];
        if (!self.viewModel.hasMoreData) {
            [self.scrollView.mj_footer endRefreshingWithNoMoreData];
        }
    }
}

- (void)bindViewModel {
    [super bindViewModel];
    
    @weakify(self)
    [[[RACObserve(self.viewModel, shouldPullToRefresh) distinctUntilChanged] deliverOnMainThread] subscribeNext:^(NSNumber *should) {
        @strongify(self)
        [self setupRefresh:should.boolValue];
    }];

    [[[RACObserve(self.viewModel, shouldScrollToMore) distinctUntilChanged] deliverOnMainThread] subscribeNext:^(NSNumber *should) {
        @strongify(self)
        [self setupMore:should.boolValue];
    }];
}

#pragma mark public
- (void)setupRefresh:(BOOL)enable {
    if (enable) {
        self.scrollView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(triggerRefresh)];
    }else {
        [self.scrollView.mj_header removeFromSuperview];
        self.scrollView.mj_header = nil;
    }
}

- (void)setupMore:(BOOL)enable {
    if (enable) {
        self.scrollView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(triggerMore)];
    }else {
        [self.scrollView.mj_footer removeFromSuperview];
        self.scrollView.mj_footer = nil;
    }
}

- (void)beginRefresh {
    self.viewModel.requestMode = BZMRequestModeRefresh;
    if (self.viewModel.error) {
        self.viewModel.error = nil;
    }
}

- (void)triggerRefresh {
    [self beginRefresh];
    @weakify(self)
    [[self.viewModel.requestRemoteDataCommand execute:@(self.viewModel.page.start)].deliverOnMainThread subscribeNext:^(id data) {
        @strongify(self)
        self.viewModel.page.index = self.viewModel.page.start;
    } completed:^{
        @strongify(self)
        [self endRefresh];
    }];
}

- (void)endRefresh {
    self.viewModel.requestMode = BZMRequestModeNone;
    [self.scrollView.mj_header endRefreshing];
    if (self.viewModel.shouldScrollToMore) {
        if (self.viewModel.hasMoreData) {
            [self.scrollView.mj_footer resetNoMoreData];
        } else {
            [self.scrollView.mj_footer endRefreshingWithNoMoreData];
        }
    }
}

- (void)beginMore {
    self.viewModel.requestMode = BZMRequestModeMore;
}

- (void)triggerMore {
    [self beginMore];
    @weakify(self)
    NSInteger pageIndex = [self.viewModel nextPageIndex];
    [[self.viewModel.requestRemoteDataCommand execute:@(pageIndex)].deliverOnMainThread subscribeNext:^(id data) {
        @strongify(self)
        self.viewModel.page.index = pageIndex;
    } completed:^{
        @strongify(self)
        [self endMore];
    }];
}

- (void)endMore {
    self.viewModel.requestMode = BZMRequestModeNone;
    if (self.viewModel.hasMoreData) {
        [self.scrollView.mj_footer endRefreshing];
    }else {
        [self.scrollView.mj_footer endRefreshingWithNoMoreData];
    }
}

#pragma mark private

#pragma mark - Delegate
#pragma mark BZMScrollViewModelDelegate
- (void)reloadData {
    [super reloadData];
    if ([self.scrollView isMemberOfClass:UIScrollView.class]) {
        [self.scrollView reloadEmptyDataSet];
    }
}

- (BOOL)handleError {
    if (!self.viewModel.error) {
        return NO;
    }
    
    BOOL handled = YES;
    BZMRequestMode requestMode = self.viewModel.requestMode;
    self.viewModel.requestMode = BZMRequestModeNone;
    
    switch (requestMode) {
        case BZMRequestModeNone: {
            [self triggerLoad];
            break;
        }
        case BZMRequestModeLoad: {
            [self reloadData];
            break;
        }
        case BZMRequestModeRefresh: {
            [self.scrollView.mj_header endRefreshing];
            @weakify(self)
            [RACScheduler.currentScheduler afterDelay:1 schedule:^{
                @strongify(self)
                [self setupRefresh:NO];
            }];
            [self setupMore:NO];
            self.viewModel.dataSource = nil;
            break;
        }
        case BZMRequestModeMore: {
            handled = NO;
            [self.scrollView.mj_footer endRefreshing];
            break;
        }
            //        case BZMRequestModeMore: {
            //            if (BZMErrorCodeEmpty == error.code) {
            //                nedUpdate = NO;
            //                [self.scrollView.mj_footer endRefreshingWithNoMoreData];
            //            }else {
            //                [self.scrollView.mj_footer endRefreshing];
            //            }
            //            break;
            //        }
            //        case BZMRequestModeHUD: {
            //            [BZMDialog hideHUD];
            //            break;
            //        }
        default: {
            handled = NO;
            break;
        }
    }
    
    
    
    //    if (BZMErrorCodeExpired == error.code) {
    //        notFilter = NO;
    //
    //        [gUser checkLoginWithFinish:^(BOOL isRelogin) {
    //            if (isRelogin) {
    //                [self triggerLoad];
    //            }
    //        } error:error];
    //    }else if (BZMErrorCodeEmpty == error.code) {
    //        notFilter = NO;
    //    }
    //
    //    self.error = error;
    //    self.requestMode = BZMRequestModeNone;
    //    if (nedUpdate) {
    //        self.dataSource = nil;
    //    }
    
    return handled;
}

- (void)reloadItemsAtIndexPaths:(NSArray *)indexPaths {
    
}

- (void)preloadNextPage {
    
}

#pragma mark DZNEmptyDataSetDelegate
- (BOOL)emptyDataSetShouldDisplay:(UIScrollView *)scrollView {
    return (self.viewModel.shouldRequestRemoteData && !self.viewModel.dataSource);
}

- (BOOL)emptyDataSetShouldAllowTouch:(UIScrollView *)scrollView {
    return YES;
}

- (BOOL)emptyDataSetShouldAllowScroll:(UIScrollView *)scrollView {
    return YES;
}

- (BOOL)emptyDataSetShouldAnimateImageView:(UIScrollView *)scrollView {
    return !self.viewModel.error;
}

- (void)emptyDataSet:(UIScrollView *)scrollView didTapButton:(UIButton *)button {
    //    if (TBErrorCodeAppLoginExpired == self.viewModel.error.code) {
    //        [(TBUser *)[TBUser current] openLoginIfNeed:^(BOOL isRelogin) {
    //            if (isRelogin) {
    //                [self triggerLoad];
    //            }
    //        } withError:self.viewModel.error];
    //    }else {
    //        [self triggerLoad];
    //    }

    // [self triggerLoad];
    
    [self handleError];
}

- (void)emptyDataSet:(UIScrollView *)scrollView didTapView:(UIView *)view {
    //    if (TBErrorCodeAppLoginExpired == self.viewModel.error.code) {
    //        [(TBUser *)[TBUser current] openLoginIfNeed:^(BOOL isRelogin) {
    //            if (isRelogin) {
    //                [self triggerLoad];
    //            }
    //        } withError:self.viewModel.error];
    //    }else {
    //        [self triggerLoad];
    //    }

    // [self triggerLoad];
    
    [self handleError];
}

#pragma mark - Class


@end
