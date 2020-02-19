//
//  BZMWebProgressView.m
//  Pods
//
//  Created by 杨建祥 on 2020/1/9.
//

#import "BZMWebProgressView.h"
#import "BZMFunction.h"

@interface BZMWebProgressView ()

@end

@implementation BZMWebProgressView
- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.userInteractionEnabled = NO;
        self.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        self.progressBarView = [[UIView alloc] init];
        self.progressBarView.qmui_left = 0;
        self.progressBarView.qmui_top = 0;
        self.progressBarView.qmui_width = 0;
        self.progressBarView.qmui_height = frame.size.height;
        self.progressBarView.dk_backgroundColorPicker = DKColorPickerWithKey(PRIMARY);
        [self addSubview:self.progressBarView];
        
        self.barAnimationDuration = 0.27f;
        self.fadeAnimationDuration = 0.27f;
        self.fadeOutDelay = 0.1f;
    }
    return self;
}

- (void)setProgress:(CGFloat)progress {
    [self setProgress:progress animated:NO];
}

- (void)setProgress:(CGFloat)progress animated:(BOOL)animated {
    BOOL isGrowing = progress > 0.0;
    [UIView animateWithDuration:(isGrowing && animated) ? self.barAnimationDuration : 0.0 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        CGRect frame = self.progressBarView.frame;
        frame.size.width = progress * self.bounds.size.width;
        self.progressBarView.frame = frame;
    } completion:nil];
    
    if (progress >= 1.0) {
        [UIView animateWithDuration:animated ? self.fadeAnimationDuration : 0.0 delay:self.fadeOutDelay options:UIViewAnimationOptionCurveEaseInOut animations:^{
            self.progressBarView.alpha = 0.0;
        } completion:^(BOOL completed){
            CGRect frame = self.progressBarView.frame;
            frame.size.width = 0;
            self.progressBarView.frame = frame;
        }];
    } else {
        [UIView animateWithDuration:animated ? self.fadeAnimationDuration : 0.0 delay:0.0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
            self.progressBarView.alpha = 1.0;
        } completion:nil];
    }
}

@end
