//
//  BZMBaseSupplementaryView.m
//  Pods
//
//  Created by 杨建祥 on 2020/1/7.
//

#import "BZMBaseSupplementaryView.h"
#import <QMUIKit/QMUIKit.h>
#import "BZMFunction.h"

@interface BZMBaseSupplementaryView ()
@property (nonatomic, strong, readwrite) id viewModel;

@end

@implementation BZMBaseSupplementaryView
- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self didInitialize];
    }
    return self;
}

- (void)didInitialize {
    self.dk_backgroundColorPicker = DKColorPickerWithKey(BG);
}

- (void)bindViewModel:(id)viewModel {
//    if (self.viewModel == viewModel) {
//        return;
//    }
    self.viewModel = viewModel;
    [self setNeedsLayout];
    [self layoutIfNeeded];
}

+ (NSString *)kind {
    return UICollectionElementKindSectionHeader;
}

@end
