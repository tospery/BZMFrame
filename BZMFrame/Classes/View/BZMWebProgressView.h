//
//  BZMWebProgressView.h
//  Pods
//
//  Created by 杨建祥 on 2020/2/24.
//

#import <UIKit/UIKit.h>

@interface BZMWebProgressView : UIView
@property (nonatomic, assign) CGFloat progress;
@property (nonatomic, assign) NSTimeInterval barAnimationDuration;
@property (nonatomic, assign) NSTimeInterval fadeAnimationDuration;
@property (nonatomic, assign) NSTimeInterval fadeOutDelay;
@property (nonatomic, strong) UIView *progressBarView;

- (void)setProgress:(CGFloat)progress animated:(BOOL)animated;

@end

