//
//  BZMNormalCollectionCell.m
//  Pods
//
//  Created by 杨建祥 on 2020/2/8.
//

#import "BZMNormalCollectionCell.h"
#import <DKNightVersion/DKNightVersion.h>
#import "BZMFunction.h"
#import "BZMNormalCollectionItem.h"
#import "BZMBorderLayer.h"
#import "UIView+BZMFrame.h"

@interface BZMNormalCollectionCell ()
@property (nonatomic, strong, readwrite) UILabel *titleLabel;
@property (nonatomic, strong, readwrite) UIImageView *arrowImageView;
@property (nonatomic, strong, readwrite) BZMNormalCollectionItem *viewModel;

@end

@implementation BZMNormalCollectionCell
@dynamic viewModel;

#pragma mark - Init
- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self.contentView addSubview:self.titleLabel];
        [self.contentView addSubview:self.arrowImageView];
        self.bzm_borderLayer.borderPosition = BZMBorderPositionBottom;
        self.bzm_borderLayer.borderInsets = @{@(BZMBorderPositionBottom): NSStringFromUIEdgeInsets(UIEdgeInsetsMake(0, 15, 0, 0))};
    }
    return self;
}

#pragma mark - View
#pragma mark - Property
- (UILabel *)titleLabel {
    if (!_titleLabel) {
        UILabel *label = [[UILabel alloc] init];
        label.font = BZMFont(15);
        label.dk_textColorPicker = DKColorPickerWithKey(TEXT);
        _titleLabel = label;
    }
    return _titleLabel;
}

- (UIImageView *)arrowImageView {
    if (!_arrowImageView) {
        UIImageView *imageView = [[UIImageView alloc] init];
        imageView.image = [UIImage.bzm_indicator imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
        imageView.dk_tintColorPicker = DKColorPickerWithKey(IND);
        [imageView sizeToFit];
        _arrowImageView = imageView;
    }
    return _arrowImageView;
}

#pragma mark - Method
- (void)layoutSublayersOfLayer:(CALayer *)layer {
    [super layoutSublayersOfLayer:layer];
    self.layer.frame = CGRectMake(self.layer.frame.origin.x, self.layer.frame.origin.y, self.bounds.size.width, self.bounds.size.height);
}

- (void)layoutSubviews {
    [super layoutSubviews];
    self.titleLabel.qmui_left = 15;
    self.titleLabel.qmui_top = self.titleLabel.qmui_topWhenCenterInSuperview;
    self.arrowImageView.qmui_right = self.contentView.qmui_width - 15;
    self.arrowImageView.qmui_top = self.arrowImageView.qmui_topWhenCenterInSuperview;
}

- (void)bindViewModel:(BZMNormalCollectionItem *)item {
    self.titleLabel.text = item.model.title;
    [self.titleLabel sizeToFit];
    [super bindViewModel:item];
}

#pragma mark - Delegate
#pragma mark - Class
+ (Class)layerClass {
    return BZMBorderLayer.class;
}

@end
