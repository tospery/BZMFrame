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
@property (nonatomic, strong, readwrite) UILabel *detailLabel;
@property (nonatomic, strong, readwrite) UIImageView *detailImageView;
@property (nonatomic, strong, readwrite) UIImageView *arrowImageView;
@property (nonatomic, strong, readwrite) BZMNormalCollectionItem *viewModel;

@end

@implementation BZMNormalCollectionCell
@dynamic viewModel;

#pragma mark - Init
- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self.contentView addSubview:self.titleLabel];
        [self.contentView addSubview:self.detailLabel];
        [self.contentView addSubview:self.detailImageView];
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

- (UILabel *)detailLabel {
    if (!_detailLabel) {
        UILabel *label = [[UILabel alloc] init];
        label.font = BZMFont(13);
        label.dk_textColorPicker = DKColorPickerWithKey(BODY);
        _detailLabel = label;
    }
    return _detailLabel;
}

- (UIImageView *)detailImageView {
    if (!_detailImageView) {
        UIImageView *imageView = [[UIImageView alloc] init];
        [imageView sizeToFit];
        _detailImageView = imageView;
    }
    return _detailImageView;
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
    
    self.detailLabel.qmui_right = self.arrowImageView.qmui_left - 6;
    if (self.arrowImageView.hidden) {
        self.detailLabel.qmui_right += self.arrowImageView.qmui_width;
    }
    self.detailLabel.qmui_top = self.detailLabel.qmui_topWhenCenterInSuperview;
    
    self.detailImageView.qmui_height = flat(self.contentView.qmui_height * 0.6);
    self.detailImageView.qmui_width = self.detailImageView.qmui_height;
    self.detailImageView.qmui_right = self.detailLabel.qmui_left - 8;
    self.detailImageView.qmui_top = self.detailImageView.qmui_topWhenCenterInSuperview;
}

- (void)bindViewModel:(BZMNormalCollectionItem *)item {
    self.titleLabel.text = item.model.title;
    [self.titleLabel sizeToFit];
    self.detailLabel.text = item.model.detail;
    [self.detailLabel sizeToFit];
    [super bindViewModel:item];
}

#pragma mark - Delegate
#pragma mark - Class
+ (Class)layerClass {
    return BZMBorderLayer.class;
}

@end
