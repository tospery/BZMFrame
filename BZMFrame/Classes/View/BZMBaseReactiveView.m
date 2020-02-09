//
//  BZMBaseReactiveView.m
//  ReactHub
//
//  Created by 杨建祥 on 2019/12/30.
//  Copyright © 2019 杨建祥. All rights reserved.
//

#import "BZMBaseReactiveView.h"
#import <QMUIKit/QMUIKit.h>
#import "BZMFunction.h"

@interface BZMBaseReactiveView ()
@property (nonatomic, strong, readwrite) id viewModel;

@end

@implementation BZMBaseReactiveView
- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.dk_backgroundColorPicker = DKColorPickerWithKey(BG);
    }
    return self;
}

- (void)bindViewModel:(id)viewModel {
    self.viewModel = viewModel;
    [self setNeedsLayout];
    [self layoutIfNeeded];
}

@end
