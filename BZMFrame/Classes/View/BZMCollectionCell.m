//
//  BZMCollectionCell.m
//  Pods
//
//  Created by 杨建祥 on 2020/2/22.
//

#import "BZMCollectionCell.h"
#import <DKNightVersion/DKNightVersion.h>
#import "BZMFunction.h"

@interface BZMCollectionCell ()
@property (nonatomic, strong, readwrite) BZMCollectionReactor *reactor;

@end

@implementation BZMCollectionCell
- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.dk_backgroundColorPicker = DKColorPickerWithKey(BG);
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    if (!self.reactor) {
        return;
    }
}

- (void)bind:(BZMCollectionReactor *)reactor {
    self.reactor = reactor;
    [self setNeedsLayout];
    [self layoutIfNeeded];
}

@end
