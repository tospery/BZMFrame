//
//  BZMScrollViewModel.m
//  ReactHub
//
//  Created by 杨建祥 on 2019/12/29.
//  Copyright © 2019 杨建祥. All rights reserved.
//

#import "BZMScrollViewModel.h"
#import "BZMConstant.h"
#import "BZMFunction.h"
#import "BZMString.h"
#import "BZMParameter.h"
#import "BZMFrameManager.h"
#import "NSAttributedString+BZMFrame.h"
#import "NSError+BZMFrame.h"
#import "NSDictionary+BZMFrame.h"
#import "UIImage+BZMFrame.h"

@interface BZMScrollViewModel ()
@property (nonatomic, strong, readwrite) RACCommand *selectCommand;

@end

@implementation BZMScrollViewModel

#pragma mark - Init
- (instancetype)initWithRouteParameters:(NSDictionary<NSString *,id> *)parameters {
    if (self = [super initWithRouteParameters:parameters]) {
        self.shouldPullToRefresh = BZMBoolMember(parameters, BZMParameter.pullRefresh, NO);
        self.shouldScrollToMore = BZMBoolMember(parameters, BZMParameter.scrollMore, NO);
        self.page = [[BZMPage alloc] init];
        self.page.start = BZMIntMember(parameters, BZMParameter.page, BZMFrameManager.share.page.start);
        self.page.size = BZMIntMember(parameters, BZMParameter.pageSize, BZMFrameManager.share.page.size);
    }
    return self;
}

- (void)didInitialize {
    [super didInitialize];
    self.selectCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
        return [RACSignal return:input];
    }];
}

#pragma mark - Public
- (NSUInteger)offsetForPage:(NSUInteger)page {
    return (page - 1) * self.page.size;
}

- (NSInteger)nextPageIndex {
    return self.page.index + 1;
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
    UIImage *image = [UIImage qmui_imageWithColor:BZMColorKey(PRIMARY) size:CGSizeMake(120, 30) cornerRadius:2.0f];
    image = [image imageWithAlignmentRectInsets:UIEdgeInsetsMake(0, -120, 0, -120)];
    return (UIControlStateNormal == state ? image : nil);
}

- (UIImage *)imageForEmptyDataSet:(UIScrollView *)scrollView {
    if (!self.error) {
        return [UIImage.bzm_loading qmui_imageWithTintColor:BZMColorKey(PRIMARY)];
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
