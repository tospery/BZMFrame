//
//  BZMReactiveView.m
//  Pods
//
//  Created by 杨建祥 on 2020/2/22.
//

#import "BZMReactiveView.h"

@interface BZMReactiveView ()
@property (nonatomic, strong, readwrite) BZMBaseReactor *reactor;

@end

@implementation BZMReactiveView

- (void)bind:(BZMBaseReactor *)reactor { 
    self.reactor = reactor;
    [self setNeedsLayout];
    [self layoutIfNeeded];
}

@end
