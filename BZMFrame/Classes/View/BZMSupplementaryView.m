//
//  BZMSupplementaryView.m
//  Pods
//
//  Created by 杨建祥 on 2020/1/7.
//

#import "BZMSupplementaryView.h"
#import <QMUIKit/QMUIKit.h>
#import "BZMFunction.h"

@interface BZMSupplementaryView ()
@property (nonatomic, strong, readwrite) id viewModel;

@end

@implementation BZMSupplementaryView
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
    self.viewModel = viewModel;
    [self setNeedsLayout];
    [self layoutIfNeeded];
}

+ (NSString *)kind {
    return UICollectionElementKindSectionHeader;
}

+ (NSString *)identifier {
    return BZMStrWithFmt(@"%@Identifier", NSStringFromClass(self));
}

//+ (CGSize)sizeForSection:(NSInteger)section {
//    return CGSizeZero;
//}

@end
