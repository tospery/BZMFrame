//
//  BZMCollectionCell.m
//  Pods
//
//  Created by 杨建祥 on 2020/1/7.
//

#import "BZMCollectionCell.h"
#import "BZMFunction.h"

@interface BZMCollectionCell ()
@property (nonatomic, strong, readwrite) BZMCollectionItem *viewModel;;

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
    if (!self.viewModel) {
        return;
    }
}

- (void)bindViewModel:(BZMCollectionItem *)item {
    self.viewModel = item;
    [self setNeedsLayout];
    [self layoutIfNeeded];
}

//+ (UIEdgeInsets)margin {
//    return UIEdgeInsetsZero;
//}
//
//+ (UIOffset)padding {
//    return UIOffsetZero;
//}

@end
