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
#pragma mark - Method
#pragma mark super
#pragma mark public
#pragma mark private
#pragma mark - Delegate
#pragma mark DZNEmptyDataSetDelegate
- (BOOL)emptyDataSetShouldDisplay:(UIScrollView *)scrollView {
    // return (self.viewModel.shouldRequestRemoteData && !self.viewModel.dataSource);
    return NO;
}

- (BOOL)emptyDataSetShouldAllowTouch:(UIScrollView *)scrollView {
    return YES;
}

- (BOOL)emptyDataSetShouldAllowScroll:(UIScrollView *)scrollView {
    return YES;
}

- (BOOL)emptyDataSetShouldAnimateImageView:(UIScrollView *)scrollView {
    // return !self.viewModel.error;
    return NO;
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
    
    // [self handleError];
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
    
    // [self handleError];
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
