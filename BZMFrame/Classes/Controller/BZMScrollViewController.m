//
//  BZMScrollViewController.m
//  Pods
//
//  Created by 杨建祥 on 2020/2/22.
//

#import "BZMScrollViewController.h"
#import <Mantle/Mantle.h>
#import <MJRefresh/MJRefresh.h>
#import <DKNightVersion/DKNightVersion.h>
#import "BZMFunction.h"
#import "BZMFrameManager.h"
#import "BZMAppDependency.h"
#import "BZMWebViewController.h"
#import "BZMLoginViewController.h"
#import "BZMCollectionViewController.h"
#import "NSError+BZMFrame.h"
#import "NSURL+BZMFrame.h"
#import "UIScrollView+BZMFrame.h"

@interface BZMScrollViewController ()
@property (nonatomic, assign, readwrite) CGFloat lastPosition;
@property (nonatomic, assign, readwrite) BZMScrollDirection scrollDirection;
@property (nonatomic, strong, readwrite) BZMScrollViewReactor *reactor;

@end

@implementation BZMScrollViewController
@dynamic reactor;

#pragma mark - Init
- (instancetype)initWithReactor:(BZMViewReactor *)reactor {
    if (self = [super initWithReactor:reactor]) {
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
    if (![self isKindOfClass:BZMCollectionViewController.class] &&
        ![self isKindOfClass:BZMWebViewController.class]) {
        UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:self.contentFrame];
        scrollView.bzm_contentView = [[UIView alloc] init];
        scrollView.bzm_contentView.frame = scrollView.bounds;
        scrollView.bzm_contentView.dk_backgroundColorPicker = DKColorPickerWithKey(BG);
        scrollView.contentSize = CGSizeMake(scrollView.qmui_width, scrollView.qmui_height + PixelOne);
        scrollView.dk_backgroundColorPicker = DKColorPickerWithKey(BG);
        scrollView.delegate = self;
        scrollView.emptyDataSetSource = self.reactor;
        scrollView.emptyDataSetDelegate = self;
        if (@available(iOS 11.0, *)) {
            scrollView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        }
        [self.view addSubview:scrollView];
        self.scrollView = scrollView;
    }
}

#pragma mark - Property

#pragma mark - Bind
- (void)bind:(BZMBaseReactor *)reactor {
    [super bind:reactor];
    @weakify(self)
    [RACObserve(self.reactor, shouldPullToRefresh).distinctUntilChanged.deliverOnMainThread subscribeNext:^(NSNumber *should) {
        @strongify(self)
        [self setupRefresh:should.boolValue];
    }];
    [RACObserve(self.reactor, shouldScrollToMore).distinctUntilChanged.deliverOnMainThread subscribeNext:^(NSNumber *should) {
        @strongify(self)
        [self setupMore:should.boolValue];
    }];
    
////    [self.reactor.errors doNext:^(id x) {
////        NSLog(@"");
////    }];
//    [self.reactor.errors subscribeNext:^(id  _Nullable x) {
//        NSLog(@"");
//    }];
}

- (void)reloadData {
    [super reloadData];
    if ([self.scrollView isMemberOfClass:UIScrollView.class]) {
        [self.scrollView reloadEmptyDataSet];
    }
}

- (BOOL)handleError {
    BOOL handled = NO;
    if (!self.reactor.error) {
        return handled;
    }
    
    BZMRequestMode requestMode = self.reactor.requestMode;
    self.reactor.requestMode = BZMRequestModeNone;
    
    handled = YES;
    switch (requestMode) {
        case BZMRequestModeNone: {
            if (self.reactor.user.isLogined) {
                [self triggerLoad];
            } else {
                if (BZMErrorCodeUnauthorized != self.reactor.error.code) {
                    [self triggerLoad];
                }
            }
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
            self.reactor.dataSource = nil;
            break;
        }
        case BZMRequestModeMore: {
            handled = NO;
            [self.scrollView.mj_footer endRefreshing];
            break;
        }
        default: {
            break;
        }
    }
    
    if (BZMErrorCodeUnauthorized == self.reactor.error.code) {
        if (self.reactor.user.isLogined) {
            [self.reactor.user logout];
        }
        if (BZMFrameManager.sharedInstance.autoLogin &&
            ![self.navigator.topViewController isKindOfClass:BZMLoginViewController.class]) {
            [self.navigator routeURL:BZMURLWithPattern(BZMFrameManager.sharedInstance.loginPattern) withParameters:nil];
        }
    }
    
    return handled;
}

#pragma mark - Load
- (void)beginLoad {
    [super beginLoad];
    [self setupRefresh:NO];
    [self setupMore:NO];
}

- (void)triggerLoad {
    [self beginLoad];
    @weakify(self)
    [[self.reactor.requestRemoteCommand execute:@(self.reactor.page.start)].deliverOnMainThread subscribeNext:^(id data) {
        @strongify(self)
        self.reactor.page.index = self.reactor.page.start;
    } completed:^{
        @strongify(self)
        [self endLoad];
    }];
}

- (void)endLoad {
    [super endLoad];
    if (self.reactor.shouldPullToRefresh) {
        [self setupRefresh:YES];
    }
    if (self.reactor.shouldScrollToMore) {
        [self setupMore:YES];
        if (!self.reactor.hasMoreData) {
            [self.scrollView.mj_footer endRefreshingWithNoMoreData];
        }
    }
}

#pragma mark - Refresh
- (void)setupRefresh:(BOOL)enable {
    if (enable) {
        self.scrollView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(triggerRefresh)];
    }else {
        [self.scrollView.mj_header removeFromSuperview];
        self.scrollView.mj_header = nil;
    }
}

- (void)beginRefresh {
    self.reactor.requestMode = BZMRequestModeRefresh;
    if (self.reactor.error) {
        self.reactor.error = nil;
    }
}

- (void)triggerRefresh {
    [self beginRefresh];
    @weakify(self)
    [[self.reactor.requestRemoteCommand execute:@(self.reactor.page.start)].deliverOnMainThread subscribeNext:^(id data) {
        @strongify(self)
        self.reactor.page.index = self.reactor.page.start;
    } completed:^{
        @strongify(self)
        [self endRefresh];
    }];
}

- (void)endRefresh {
    self.reactor.requestMode = BZMRequestModeNone;
    [self.scrollView.mj_header endRefreshing];
    if (self.reactor.shouldScrollToMore) {
        if (self.reactor.hasMoreData) {
            [self.scrollView.mj_footer resetNoMoreData];
        } else {
            [self.scrollView.mj_footer endRefreshingWithNoMoreData];
        }
    }
}

#pragma mark - More
- (void)setupMore:(BOOL)enable {
    if (enable) {
        self.scrollView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(triggerMore)];
    }else {
        [self.scrollView.mj_footer removeFromSuperview];
        self.scrollView.mj_footer = nil;
    }
}

- (void)beginMore {
    self.reactor.requestMode = BZMRequestModeMore;
}

- (void)triggerMore {
    [self beginMore];
    @weakify(self)
    NSInteger pageIndex = [self.reactor nextPageIndex];
    [[self.reactor.requestRemoteCommand execute:@(pageIndex)].deliverOnMainThread subscribeNext:^(id data) {
        @strongify(self)
        self.reactor.page.index = pageIndex;
    } completed:^{
        @strongify(self)
        [self endMore];
    }];
}

- (void)endMore {
    self.reactor.requestMode = BZMRequestModeNone;
    if (self.reactor.hasMoreData) {
        [self.scrollView.mj_footer endRefreshing];
    }else {
        [self.scrollView.mj_footer endRefreshingWithNoMoreData];
    }
}

#pragma mark - Delegate
#pragma mark DZNEmptyDataSetDelegate
- (BOOL)emptyDataSetShouldDisplay:(UIScrollView *)scrollView {
    return (self.reactor.shouldRequestRemoteData && !self.reactor.dataSource);
}

- (BOOL)emptyDataSetShouldAllowTouch:(UIScrollView *)scrollView {
    return YES;
}

- (BOOL)emptyDataSetShouldAllowScroll:(UIScrollView *)scrollView {
    return YES;
}

- (BOOL)emptyDataSetShouldAnimateImageView:(UIScrollView *)scrollView {
    return !self.reactor.error;
}

- (void)emptyDataSet:(UIScrollView *)scrollView didTapButton:(UIButton *)button {
    [self handleError];
}

- (void)emptyDataSet:(UIScrollView *)scrollView didTapView:(UIView *)view {
    [self handleError];
}

#pragma mark UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    CGFloat currentPostion = scrollView.contentOffset.y;
    CGFloat offset = currentPostion - self.lastPosition;
    if (offset > 0) {
        self.scrollDirection = BZMScrollDirectionUp;
    } else if (offset < 0) {
        self.scrollDirection = BZMScrollDirectionDown;
    } else {
        self.scrollDirection = BZMScrollDirectionNone;
    }
    self.lastPosition = currentPostion;
}

#pragma mark - Class

@end
