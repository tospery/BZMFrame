//
//  BZMScrollViewReactor.m
//  Pods
//
//  Created by 杨建祥 on 2020/2/22.
//

#import "BZMScrollViewReactor.h"
#import "BZMConstant.h"
#import "BZMFunction.h"
#import "BZMParameter.h"
#import "BZMFrameManager.h"
#import "BZMAppDependency.h"
#import "BZMLoginViewController.h"
#import "NSDictionary+BZMFrame.h"
#import "NSError+BZMFrame.h"
#import "NSAttributedString+BZMFrame.h"
#import "UIFont+BZMFrame.h"
#import "UIImage+BZMFrame.h"

@interface BZMScrollViewReactor ()
@property (nonatomic, strong, readwrite) BZMPage *page;
@property (nonatomic, strong, readwrite) RACCommand *selectCommand;

@end

@implementation BZMScrollViewReactor

#pragma mark - Init
- (instancetype)initWithRouteParameters:(NSDictionary *)parameters {
    if (self = [super initWithRouteParameters:parameters]) {
        self.shouldPullToRefresh = BZMBoolMember(parameters, BZMParameter.pullRefresh, NO);
        self.shouldScrollToMore = BZMBoolMember(parameters, BZMParameter.scrollMore, NO);
        self.page = [[BZMPage alloc] init];
        self.page.start = BZMIntMember(parameters, BZMParameter.page, BZMFrameManager.sharedInstance.page.start);
        self.page.size = BZMIntMember(parameters, BZMParameter.pageSize, BZMFrameManager.sharedInstance.page.size);
    }
    return self;
}

- (void)didInitialize {
    [super didInitialize];
}

#pragma mark - View
#pragma mark - Property
- (RACCommand *)selectCommand {
    if (!_selectCommand) {
        RACCommand *command = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
            return [RACSignal return:input];
        }];
        _selectCommand = command;
    }
    return _selectCommand;
}

#pragma mark - Page
- (NSInteger)offsetForPage:(NSInteger)page {
    return (page - 1) * self.page.size;
}

- (NSInteger)nextPageIndex {
    return self.page.index + 1;
}

#pragma mark - Error
- (BOOL)handleError {
    BOOL handled = NO;
    if (!self.error) {
        return handled;
    }
    
    BZMRequestMode requestMode = self.requestMode;
    self.requestMode = BZMRequestModeNone;
    
    switch (requestMode) {
        case BZMRequestModeNone: {
            if (self.user.isLogined) {
                [self.load sendNext:nil];
            } else {
                if (BZMErrorCodeUnauthorized != self.error.code) {
                    [self.load sendNext:nil];
                }
            }
            break;
        }
        case BZMRequestModeLoad: {
            handled = YES;
            self.dataSource = nil;
            break;
        }
        case BZMRequestModeRefresh: {
//            [self.scrollView.mj_header endRefreshing];
//            @weakify(self)
//            [RACScheduler.currentScheduler afterDelay:1 schedule:^{
//                @strongify(self)
//                [self setupRefresh:NO];
//            }];
//            [self setupMore:NO];
//            self.viewModel.dataSource = nil;
            break;
        }
        case BZMRequestModeMore: {
//            handled = NO;
//            [self.scrollView.mj_footer endRefreshing];
            break;
        }
        default: {
            break;
        }
    }
    
    if (BZMErrorCodeUnauthorized == self.error.code) {
        if (self.user.isLogined) {
            [self.user logout];
        }
        if (BZMFrameManager.sharedInstance.autoLogin && ![BZMAppDependency.sharedInstance.navigator.topViewController isKindOfClass:BZMLoginViewController.class]) {
            [self.navigate sendNext:RACTuplePack(BZMURLWithPattern(BZMFrameManager.sharedInstance.loginPattern), nil)];
        }
    }
    
    return handled;
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
    return [NSAttributedString bzm_attributedStringWithString:self.error.bzm_displayMessage color:BZMColorKey(FOOT) font:BZMFont(14.0f)];
}

- (NSAttributedString *)buttonTitleForEmptyDataSet:(UIScrollView *)scrollView forState:(UIControlState)state {
    if (!self.error) {
        return nil;
    }
    return [NSAttributedString bzm_attributedStringWithString:self.error.bzm_retryTitle color:(UIControlStateNormal == state ? UIColorWhite : [UIColorWhite colorWithAlphaComponent:0.8]) font:BZMFont(15.0f)];
}

- (UIImage *)buttonBackgroundImageForEmptyDataSet:(UIScrollView *)scrollView forState:(UIControlState)state {
    UIImage *image = [UIImage qmui_imageWithColor:BZMColorKey(TINT) size:CGSizeMake(120, 30) cornerRadius:2.0f];
    image = [image imageWithAlignmentRectInsets:UIEdgeInsetsMake(0, -120, 0, -120)];
    return (UIControlStateNormal == state ? image : nil);
}

- (UIImage *)imageForEmptyDataSet:(UIScrollView *)scrollView {
    if (!self.error) {
        return [UIImage.bzm_loading qmui_imageWithTintColor:BZMColorKey(TINT)];
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

#pragma mark - Class

@end
