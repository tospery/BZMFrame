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
#import "BZMWebViewController.h"
#import "BZMCollectionViewController.h"
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

#pragma mark - Reload
- (void)reloadData {
    [super reloadData];
    if ([self.scrollView isMemberOfClass:UIScrollView.class]) {
        [self.scrollView reloadEmptyDataSet];
    }
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
    [self.reactor handleError];
}

- (void)emptyDataSet:(UIScrollView *)scrollView didTapView:(UIView *)view {
    [self.reactor handleError];
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
