//
//  BZMPageMenuIndicatorLineView.m
//  Pods
//
//  Created by 杨建祥 on 2020/1/10.
//

#import "BZMPageMenuIndicatorLineView.h"
#import "BZMFunction.h"
#import "BZMPageFactory.h"
#import "BZMPageMenuAnimator.h"

@interface BZMPageMenuIndicatorLineView ()
@property (nonatomic, strong) BZMPageMenuAnimator *animator;
@end

@implementation BZMPageMenuIndicatorLineView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _lineStyle = BZMPageMenuIndicatorLineStyleNormal;
        _lineScrollOffsetX = 10;
        self.indicatorHeight = 3;
    }
    return self;
}

#pragma mark - BZMPageMenuIndicator

- (void)refreshState:(BZMPageMenuIndicatorModel *)model {
    self.backgroundColor = self.indicatorColor;
    self.layer.cornerRadius = [self indicatorCornerRadiusValue:model.selectedCellFrame];

    CGFloat selectedLineWidth = [self indicatorWidthValue:model.selectedCellFrame];
    CGFloat x = model.selectedCellFrame.origin.x + (model.selectedCellFrame.size.width - selectedLineWidth)/2;
    CGFloat y = self.superview.bounds.size.height - [self indicatorHeightValue:model.selectedCellFrame] - self.verticalMargin;
    if (self.componentPosition == BZMPageMenuComponentPositionTop) {
        y = self.verticalMargin;
    }
    self.frame = CGRectMake(x, y, selectedLineWidth, [self indicatorHeightValue:model.selectedCellFrame]);
}

- (void)contentScrollViewDidScroll:(BZMPageMenuIndicatorModel *)model {
    if (self.animator.isExecuting) {
        [self.animator invalid];
        self.animator = nil;
    }
    CGRect rightCellFrame = model.rightCellFrame;
    CGRect leftCellFrame = model.leftCellFrame;
    CGFloat percent = model.percent;
    CGFloat targetX = leftCellFrame.origin.x;
    CGFloat targetWidth = [self indicatorWidthValue:leftCellFrame];

    CGFloat leftWidth = targetWidth;
    CGFloat rightWidth = [self indicatorWidthValue:rightCellFrame];
    CGFloat leftX = leftCellFrame.origin.x + (leftCellFrame.size.width - leftWidth)/2;
    CGFloat rightX = rightCellFrame.origin.x + (rightCellFrame.size.width - rightWidth)/2;

    if (self.lineStyle == BZMPageMenuIndicatorLineStyleNormal) {
        targetX = [BZMPageFactory interpolationFrom:leftX to:rightX percent:percent];
        if (self.indicatorWidth == BZMPageAutomaticDimension) {
            targetWidth = [BZMPageFactory interpolationFrom:leftWidth to:rightWidth percent:percent];
        }
    }else if (self.lineStyle == BZMPageMenuIndicatorLineStyleLengthen) {
        CGFloat maxWidth = rightX - leftX + rightWidth;
        //前50%，只增加width；后50%，移动x并减小width
        if (percent <= 0.5) {
            targetX = leftX;
            targetWidth = [BZMPageFactory interpolationFrom:leftWidth to:maxWidth percent:percent*2];
        }else {
            targetX = [BZMPageFactory interpolationFrom:leftX to:rightX percent:(percent - 0.5)*2];
            targetWidth = [BZMPageFactory interpolationFrom:maxWidth to:rightWidth percent:(percent - 0.5)*2];
        }
    }else if (self.lineStyle == BZMPageMenuIndicatorLineStyleLengthenOffset) {
        //前50%，增加width，并少量移动x；后50%，少量移动x并减小width
        CGFloat offsetX = self.lineScrollOffsetX;//x的少量偏移量
        CGFloat maxWidth = rightX - leftX + rightWidth - offsetX*2;
        if (percent <= 0.5) {
            targetX = [BZMPageFactory interpolationFrom:leftX to:leftX + offsetX percent:percent*2];;
            targetWidth = [BZMPageFactory interpolationFrom:leftWidth to:maxWidth percent:percent*2];
        }else {
            targetX = [BZMPageFactory interpolationFrom:(leftX + offsetX) to:rightX percent:(percent - 0.5)*2];
            targetWidth = [BZMPageFactory interpolationFrom:maxWidth to:rightWidth percent:(percent - 0.5)*2];
        }
    }
    //允许变动frame的情况：1、允许滚动；2、不允许滚动，但是已经通过手势滚动切换一页内容了；
    if (self.isScrollEnabled == YES || (self.isScrollEnabled == NO && percent == 0)) {
        CGRect frame = self.frame;
        frame.origin.x = targetX;
        frame.size.width = targetWidth;
        self.frame = frame;
    }
}

- (void)selectedCell:(BZMPageMenuIndicatorModel *)model {
    CGRect targetIndicatorFrame = self.frame;
    CGFloat targetIndicatorWidth = [self indicatorWidthValue:model.selectedCellFrame];
    targetIndicatorFrame.origin.x = model.selectedCellFrame.origin.x + (model.selectedCellFrame.size.width - targetIndicatorWidth)/2.0;
    targetIndicatorFrame.size.width = targetIndicatorWidth;
    if (self.isScrollEnabled) {
        if (self.scrollStyle == BZMPageMenuIndicatorScrollStyleSameAsUserScroll) {
            if (self.animator.isExecuting) {
                [self.animator invalid];
                self.animator = nil;
            }
            CGFloat leftX = 0;
            CGFloat rightX = 0;
            CGFloat leftWidth = 0;
            CGFloat rightWidth = 0;
            BOOL isNeedReversePercent = NO;
            if (self.frame.origin.x > model.selectedCellFrame.origin.x) {
                leftWidth = [self indicatorWidthValue:model.selectedCellFrame];
                rightWidth = self.frame.size.width;
                leftX = model.selectedCellFrame.origin.x + (model.selectedCellFrame.size.width - leftWidth)/2;;
                rightX = self.frame.origin.x;
                isNeedReversePercent = YES;
            }else {
                leftWidth = self.frame.size.width;
                rightWidth = [self indicatorWidthValue:model.selectedCellFrame];
                leftX = self.frame.origin.x;
                rightX = model.selectedCellFrame.origin.x + (model.selectedCellFrame.size.width - rightWidth)/2;
            }
            __weak typeof(self) weakSelf = self;
            if (self.lineStyle == BZMPageMenuIndicatorLineStyleNormal) {
                [UIView animateWithDuration:self.scrollAnimationDuration delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
                    self.frame = targetIndicatorFrame;
                } completion: nil];
            }else if (self.lineStyle == BZMPageMenuIndicatorLineStyleLengthen) {
                CGFloat maxWidth = rightX - leftX + rightWidth;
                //前50%，只增加width；后50%，移动x并减小width
                self.animator = [[BZMPageMenuAnimator alloc] init];
                self.animator.progressCallback = ^(CGFloat percent) {
                    if (isNeedReversePercent) {
                        percent = 1 - percent;
                    }
                    CGFloat targetX = 0;
                    CGFloat targetWidth = 0;
                    if (percent <= 0.5) {
                        targetX = leftX;
                        targetWidth = [BZMPageFactory interpolationFrom:leftWidth to:maxWidth percent:percent*2];
                    }else {
                        targetX = [BZMPageFactory interpolationFrom:leftX to:rightX percent:(percent - 0.5)*2];
                        targetWidth = [BZMPageFactory interpolationFrom:maxWidth to:rightWidth percent:(percent - 0.5)*2];
                    }
                    CGRect toFrame = weakSelf.frame;
                    toFrame.origin.x = targetX;
                    toFrame.size.width = targetWidth;
                    weakSelf.frame = toFrame;
                };
                [self.animator start];
            }else if (self.lineStyle == BZMPageMenuIndicatorLineStyleLengthenOffset) {
                //前50%，增加width，并少量移动x；后50%，少量移动x并减小width
                CGFloat offsetX = self.lineScrollOffsetX;//x的少量偏移量
                CGFloat maxWidth = rightX - leftX + rightWidth - offsetX*2;
                self.animator = [[BZMPageMenuAnimator alloc] init];
                self.animator.progressCallback = ^(CGFloat percent) {
                    if (isNeedReversePercent) {
                        percent = 1 - percent;
                    }
                    CGFloat targetX = 0;
                    CGFloat targetWidth = 0;
                    if (percent <= 0.5) {
                        targetX = [BZMPageFactory interpolationFrom:leftX to:leftX + offsetX percent:percent*2];;
                        targetWidth = [BZMPageFactory interpolationFrom:leftWidth to:maxWidth percent:percent*2];
                    }else {
                        targetX = [BZMPageFactory interpolationFrom:(leftX + offsetX) to:rightX percent:(percent - 0.5)*2];
                        targetWidth = [BZMPageFactory interpolationFrom:maxWidth to:rightWidth percent:(percent - 0.5)*2];
                    }
                    CGRect toFrame = weakSelf.frame;
                    toFrame.origin.x = targetX;
                    toFrame.size.width = targetWidth;
                    weakSelf.frame = toFrame;
                };
                [self.animator start];
            }
        }else if (self.scrollStyle == BZMPageMenuIndicatorScrollStyleSimple) {
            [UIView animateWithDuration:self.scrollAnimationDuration delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
                self.frame = targetIndicatorFrame;
            } completion: nil];
        }
    }else {
        self.frame = targetIndicatorFrame;
    }
}

@end

