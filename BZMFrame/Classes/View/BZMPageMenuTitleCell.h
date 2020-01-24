//
//  BZMPageMenuTitleCell.h
//  Pods
//
//  Created by 杨建祥 on 2020/1/10.
//

#import "BZMPageMenuIndicatorCell.h"
#import "BZMType.h"

@class BZMPageMenuTitleItem;

@interface BZMPageMenuTitleCell : BZMPageMenuIndicatorCell
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *maskTitleLabel;
@property (nonatomic, strong) NSLayoutConstraint *titleLabelCenterX;
@property (nonatomic, strong) NSLayoutConstraint *titleLabelCenterY;
@property (nonatomic, strong) NSLayoutConstraint *maskTitleLabelCenterX;

- (BZMPageMenuCellSelectedAnimationBlock)preferredTitleZoomAnimationBlock:(BZMPageMenuTitleItem *)item baseScale:(CGFloat)baseScale;
- (BZMPageMenuCellSelectedAnimationBlock)preferredTitleStrokeWidthAnimationBlock:(BZMPageMenuTitleItem *)item attributedString:(NSMutableAttributedString *)attributedString;
- (BZMPageMenuCellSelectedAnimationBlock)preferredTitleColorAnimationBlock:(BZMPageMenuTitleItem *)item;

@end

