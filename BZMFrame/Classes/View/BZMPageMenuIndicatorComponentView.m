//
//  BZMPageMenuIndicatorComponentView.m
//  Pods
//
//  Created by 杨建祥 on 2020/1/10.
//

#import "BZMPageMenuIndicatorComponentView.h"
#import "BZMFunction.h"

@implementation BZMPageMenuIndicatorComponentView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _componentPosition = BZMPageMenuComponentPositionBottom;
        _scrollEnabled = YES;
        _verticalMargin = 0;
        _scrollAnimationDuration = 0.25;
        _indicatorWidth = BZMPageAutomaticDimension;
        _indicatorWidthIncrement = 0;
        _indicatorHeight = 3;
        _indicatorCornerRadius = BZMPageAutomaticDimension;
        _indicatorColor = [UIColor redColor];
        _scrollStyle = BZMPageMenuIndicatorScrollStyleSimple;
    }
    return self;
}

- (CGFloat)indicatorWidthValue:(CGRect)cellFrame {
    if (self.indicatorWidth == BZMPageAutomaticDimension) {
        return cellFrame.size.width + self.indicatorWidthIncrement;
    }
    return self.indicatorWidth + self.indicatorWidthIncrement;
}

- (CGFloat)indicatorHeightValue:(CGRect)cellFrame {
    if (self.indicatorHeight == BZMPageAutomaticDimension) {
        return cellFrame.size.height;
    }
    return self.indicatorHeight;
}

- (CGFloat)indicatorCornerRadiusValue:(CGRect)cellFrame {
    if (self.indicatorCornerRadius == BZMPageAutomaticDimension) {
        return [self indicatorHeightValue:cellFrame]/2;
    }
    return self.indicatorCornerRadius;
}

#pragma mark - BZMPageMenuIndicator

- (void)refreshState:(BZMPageMenuIndicatorModel *)model {

}

- (void)contentScrollViewDidScroll:(BZMPageMenuIndicatorModel *)model {

}

- (void)selectedCell:(BZMPageMenuIndicatorModel *)model {
    
}

@end
