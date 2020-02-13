//
//  BZMNavigationBar.m
//  Pods
//
//  Created by 杨建祥 on 2020/2/13.
//

#import "BZMNavigationBar.h"
#import <DKNightVersion/DKNightVersion.h>
#import "BZMFunction.h"

@interface BZMNavigationBar ()
@property (nonatomic, strong, readwrite) UILabel *titleLabel;
@property (nonatomic, strong, readwrite) UIImageView *bgImageView;

@end

@implementation BZMNavigationBar
#pragma mark - Init
- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        // self.backgroundColor = UIColor.redColor;
        self.dk_backgroundColorPicker = DKColorPickerWithKey(BG);
//        self.qmui_borderPosition = QMUIViewBorderPositionBottom;
//        self.qmui_borderWidth = PixelOne;
//        self.qmui_borderColor = BZMColorKey(SEP);
        //[self addSubview:self.bgImageView];
        [self addSubview:self.titleLabel];
    }
    return self;
}

#pragma mark - View
#pragma mark - Property
- (UILabel *)titleLabel {
    if (!_titleLabel) {
        UILabel *label = [[UILabel alloc] init];
        label.backgroundColor = UIColor.greenColor;
        label.font = [UIFont systemFontOfSize:17];
        label.textAlignment = NSTextAlignmentCenter;
        // label.dk_textColorPicker = DKColorPickerWithKey(TEXT);
        label.textColor = UIColor.orangeColor;
        [label sizeToFit];
        _titleLabel = label;
    }
    return _titleLabel;
}

//- (UIImageView *)bgImageView {
//    if (!_bgImageView) {
//        UIImageView *imageView = [[UIImageView alloc] init];
//        imageView.backgroundColor = UIColorClear;
//        [imageView sizeToFit];
//        _bgImageView = imageView;
//    }
//    return _bgImageView;
//}

#pragma mark - Method
- (CGSize)sizeThatFits:(CGSize)size {
    return CGSizeMake(BZMScreenWidth, BZMNavContentTopConstant);
}

- (void)layoutSubviews {
    [super layoutSubviews];
//    id aaa = self.titleLabel.text;
//    [self.titleLabel sizeToFit];
//    self.titleLabel.frame = self.bounds;
//    self.titleLabel.qmui_left = self.titleLabel.qmui_leftWhenCenterInSuperview;
//    self.titleLabel.qmui_top = self.titleLabel.qmui_topWhenCenterInSuperview;
    
    // self.titleLabel.frame = CGRectMake(0, 0, 200, 64);
    self.titleLabel.frame = self.bounds;
}

#pragma mark - Delegate
#pragma mark - Class

@end
