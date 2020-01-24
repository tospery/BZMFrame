//
//  BZMScrollViewModel.m
//  ReactHub
//
//  Created by 杨建祥 on 2019/12/29.
//  Copyright © 2019 杨建祥. All rights reserved.
//

#import "BZMScrollViewModel.h"
#import "BZMConst.h"
#import "BZMFunction.h"
#import "BZMString.h"
#import "BZMParam.h"
#import "BZMFrameManager.h"
#import "NSAttributedString+BZMFrame.h"
#import "NSError+BZMFrame.h"
#import "NSDictionary+BZMFrame.h"

@interface BZMScrollViewModel ()

@end

@implementation BZMScrollViewModel
@dynamic delegate;

#pragma mark - Init
- (instancetype)initWithRouteParameters:(NSDictionary<NSString *,id> *)parameters {
    if (self = [super initWithRouteParameters:parameters]) {
        self.shouldPullToRefresh = BZMBoolMember(parameters, BZMParam.pullRefresh, NO);
        self.shouldScrollToMore = BZMBoolMember(parameters, BZMParam.scrollMore, NO);
        self.page = [[BZMPage alloc] init];
        self.page.start = BZMIntMember(parameters, BZMParam.page, BZMFrameManager.share.page.start);
        self.page.size = BZMIntMember(parameters, BZMParam.pageSize, BZMFrameManager.share.page.size);
    }
    return self;
}

- (void)didInitialize {
    [super didInitialize];
}

#pragma mark - Accessor
//- (NSMutableArray *)preloadPages {
//    if (!_preloadPages) {
//        NSMutableArray *mArr = [NSMutableArray array];
//        _preloadPages = mArr;
//    }
//    return _preloadPages;
//}

#pragma mark - Public
- (NSUInteger)offsetForPage:(NSUInteger)page {
    return (page - 1) * self.page.size;
}

- (NSInteger)nextPageIndex {
    return self.page.index + 1;
}

- (BOOL)filterError:(NSError *)error {
//
//    switch (self.requestMode) {
//        case BZMRequestModeLoad:
//        case BZMRequestModeUpdate: {
//            break;
//        }
//        case BZMRequestModeRefresh: {
//            [self.scrollView.mj_header endRefreshing];
//            break;
//        }
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
//        default:
//            break;
//    }
//
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
//
//    return notFilter;
    
    BOOL canFilter = YES;
    BOOL needUpdate = YES;

    //    BZMRequestModeNone,
    //    BZMRequestModeLoad,
    //    BZMRequestModeUpdate,
    //    BZMRequestModeRefresh,
    //    BZMRequestModeMore,
    //    BZMRequestModeToast
    
    switch (self.requestMode) {
        case BZMRequestModeLoad:
        case BZMRequestModeRefresh: {
            canFilter = NO;
            break;
        }
        default:
            break;
    }
    
    return canFilter;
}

#pragma mark - Delegate
#pragma mark DZNEmptyDataSetSource
- (NSAttributedString *)titleForEmptyDataSet:(UIScrollView *)scrollView {
    if (!self.error) {
        return nil;
    }
    return [NSAttributedString bzm_attributedStringWithString:self.error.bzm_displayTitle color:BZMColorKey(TEXT) font:BZMFont(16.0f)];
}

- (NSAttributedString *)descriptionForEmptyDataSet:(UIScrollView *)scrollView {
    if (!self.error) {
        return nil;
    }
    return [NSAttributedString bzm_attributedStringWithString:self.error.bzm_displayMessage color:BZMColorKey(PLACEHOLDER) font:BZMFont(14.0f)];
}

- (NSAttributedString *)buttonTitleForEmptyDataSet:(UIScrollView *)scrollView forState:(UIControlState)state {
    if (!self.error) {
        return nil;
    }
    return [NSAttributedString bzm_attributedStringWithString:self.error.bzm_retryTitle color:(UIControlStateNormal == state ? BZMColorWhite : [BZMColorWhite colorWithAlphaComponent:0.8]) font:BZMFont(15.0f)];
}

- (UIImage *)buttonBackgroundImageForEmptyDataSet:(UIScrollView *)scrollView forState:(UIControlState)state {
    UIImage *image = [UIImage qmui_imageWithColor:BZMColorKey(TINT) size:CGSizeMake(120, 30) cornerRadius:2.0f];
    image = [image imageWithAlignmentRectInsets:UIEdgeInsetsMake(0, -120, 0, -120)];
    return (UIControlStateNormal == state ? image : nil);
}

- (UIImage *)imageForEmptyDataSet:(UIScrollView *)scrollView {
    if (!self.error) {
        return [BZMFrameManager.share.loadingImage qmui_imageWithTintColor:BZMColorKey(TINT)];
    }
    return self.error.bzm_displayImage;
}

- (CAAnimation *)imageAnimationForEmptyDataSet:(UIScrollView *)scrollView {
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"transform"];
    animation.fromValue = [NSValue valueWithCATransform3D:CATransform3DIdentity];
    animation.toValue = [NSValue valueWithCATransform3D: CATransform3DMakeRotation(M_PI_2, 0.0, 0.0, 1.0) ];
    animation.duration = 0.25;
    animation.cumulative = YES;
    animation.repeatCount = MAXFLOAT;
    animation.removedOnCompletion = NO;
    return animation;
}

- (UIColor *)backgroundColorForEmptyDataSet:(UIScrollView *)scrollView {
    return BZMColorKey(BG);
}

@end
