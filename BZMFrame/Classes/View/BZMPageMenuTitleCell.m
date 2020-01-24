//
//  BZMPageMenuTitleCell.m
//  Pods
//
//  Created by 杨建祥 on 2020/1/10.
//

#import "BZMPageMenuTitleCell.h"
#import "BZMPageMenuTitleItem.h"
#import "BZMPageFactory.h"

@interface BZMPageMenuTitleCell ()
@property (nonatomic, strong) CALayer *titleMaskLayer;
@property (nonatomic, strong) CALayer *maskTitleMaskLayer;
@property (nonatomic, strong) NSLayoutConstraint *maskTitleLabelCenterY;

@end

@implementation BZMPageMenuTitleCell
- (void)didInitialize
{
    [super didInitialize];

    _titleLabel = [[UILabel alloc] init];
    self.titleLabel.clipsToBounds = YES;
    self.titleLabel.textAlignment = NSTextAlignmentCenter;
    self.titleLabel.translatesAutoresizingMaskIntoConstraints = NO;
    [self.contentView addSubview:self.titleLabel];

    self.titleLabelCenterX = [NSLayoutConstraint constraintWithItem:self.titleLabel attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeCenterX multiplier:1 constant:0];
    self.titleLabelCenterY = [NSLayoutConstraint constraintWithItem:self.titleLabel attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeCenterY multiplier:1 constant:0];
    self.titleLabelCenterX.active = YES;
    self.titleLabelCenterY.active = YES;

    _titleMaskLayer = [CALayer layer];
    self.titleMaskLayer.backgroundColor = [UIColor redColor].CGColor;

    _maskTitleLabel = [[UILabel alloc] init];
    self.maskTitleLabel.hidden = YES;
    self.maskTitleLabel.translatesAutoresizingMaskIntoConstraints = NO;
    self.maskTitleLabel.textAlignment = NSTextAlignmentCenter;
    [self.contentView addSubview:self.maskTitleLabel];

    self.maskTitleLabelCenterX = [NSLayoutConstraint constraintWithItem:self.maskTitleLabel attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeCenterX multiplier:1 constant:0];
    self.maskTitleLabelCenterY = [NSLayoutConstraint constraintWithItem:self.maskTitleLabel attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeCenterY multiplier:1 constant:0];
    self.maskTitleLabelCenterX.active = YES;
    self.maskTitleLabelCenterY.active = YES;

    _maskTitleMaskLayer = [CALayer layer];
    self.maskTitleMaskLayer.backgroundColor = [UIColor redColor].CGColor;
    self.maskTitleLabel.layer.mask = self.maskTitleMaskLayer;
}

- (void)layoutSubviews {
    [super layoutSubviews];

    //因为titleLabel是通过约束布局的，在layoutSubviews方法中，它的frame并没有确定。像子类BZMPageMenuNumberCell中的numberLabel需要依赖于titleLabel的frame进行布局。所以这里必须立马触发self.contentView的视图布局。
    [self.contentView setNeedsLayout];
    [self.contentView layoutIfNeeded];
    BZMPageMenuTitleItem *myItem = (BZMPageMenuTitleItem *)self.viewModel;
    switch (myItem.titleLabelAnchorPointStyle) {
        case BZMPageMenuTitleLabelAnchorPointStyleCenter:
            self.titleLabelCenterY.constant = 0 + myItem.titleLabelVerticalOffset;
            break;
        case BZMPageMenuTitleLabelAnchorPointStyleTop:
        {
            CGFloat percent = (myItem.titleLabelCurrentZoomScale - myItem.titleLabelNormalZoomScale)/(myItem.titleLabelSelectedZoomScale - myItem.titleLabelNormalZoomScale);
            self.titleLabelCenterY.constant = -self.titleLabel.bounds.size.height/2 - myItem.titleLabelVerticalOffset - myItem.titleLabelZoomSelectedVerticalOffset*percent;
        }
            break;
        case BZMPageMenuTitleLabelAnchorPointStyleBottom:
        {
            CGFloat percent = (myItem.titleLabelCurrentZoomScale - myItem.titleLabelNormalZoomScale)/(myItem.titleLabelSelectedZoomScale - myItem.titleLabelNormalZoomScale);
            self.titleLabelCenterY.constant = self.titleLabel.bounds.size.height/2 + myItem.titleLabelVerticalOffset + myItem.titleLabelZoomSelectedVerticalOffset*percent;
        }
            break;
        default:
            break;
    }
}

- (void)bindViewModel:(BZMPageMenuItem *)item {
    [super bindViewModel:item];

    BZMPageMenuTitleItem *myItem = (BZMPageMenuTitleItem *)item;
    self.titleLabel.numberOfLines = myItem.titleNumberOfLines;
    self.maskTitleLabel.numberOfLines = myItem.titleNumberOfLines;
    switch (myItem.titleLabelAnchorPointStyle) {
        case BZMPageMenuTitleLabelAnchorPointStyleCenter:
            self.titleLabel.layer.anchorPoint = CGPointMake(0.5, 0.5);
            self.maskTitleLabel.layer.anchorPoint = CGPointMake(0.5, 0.5);
            break;
        case BZMPageMenuTitleLabelAnchorPointStyleTop:
            self.titleLabel.layer.anchorPoint = CGPointMake(0.5, 0);
            self.maskTitleLabel.layer.anchorPoint = CGPointMake(0.5, 0);
            break;
        case BZMPageMenuTitleLabelAnchorPointStyleBottom:
            self.titleLabel.layer.anchorPoint = CGPointMake(0.5, 1);
            self.maskTitleLabel.layer.anchorPoint = CGPointMake(0.5, 1);
            break;
        default:
            break;
    }

    if (myItem.isTitleLabelZoomEnabled) {
        //先把font设置为缩放的最大值，再缩小到最小值，最后根据当前的titleLabelZoomScale值，进行缩放更新。这样就能避免transform从小到大时字体模糊
        UIFont *maxScaleFont = [UIFont fontWithDescriptor:myItem.titleFont.fontDescriptor size:myItem.titleFont.pointSize*myItem.titleLabelSelectedZoomScale];
        CGFloat baseScale = myItem.titleFont.lineHeight/maxScaleFont.lineHeight;
        if (myItem.isSelectedAnimationEnabled && [self checkCanStartSelectedAnimation:myItem]) {
            BZMPageMenuCellSelectedAnimationBlock block = [self preferredTitleZoomAnimationBlock:myItem baseScale:baseScale];
            [self addSelectedAnimationBlock:block];
        }else {
            self.titleLabel.font = maxScaleFont;
            self.maskTitleLabel.font = maxScaleFont;
            CGAffineTransform currentTransform = CGAffineTransformMakeScale(baseScale*myItem.titleLabelCurrentZoomScale, baseScale*myItem.titleLabelCurrentZoomScale);
            self.titleLabel.transform = currentTransform;
            self.maskTitleLabel.transform = currentTransform;
        }
    }else {
        if (myItem.isSelected) {
            self.titleLabel.font = myItem.titleSelectedFont;
            self.maskTitleLabel.font = myItem.titleSelectedFont;
        }else {
            self.titleLabel.font = myItem.titleFont;
            self.maskTitleLabel.font = myItem.titleFont;
        }
    }

    NSString *titleString = myItem.title ? myItem.title : @"";
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:titleString];
    if (myItem.isTitleLabelStrokeWidthEnabled) {
        if (myItem.isSelectedAnimationEnabled && [self checkCanStartSelectedAnimation:myItem]) {
            BZMPageMenuCellSelectedAnimationBlock block = [self preferredTitleStrokeWidthAnimationBlock:myItem attributedString:attributedString];
            [self addSelectedAnimationBlock:block];
        }else {
            [attributedString addAttribute:NSStrokeWidthAttributeName value:@(myItem.titleLabelCurrentStrokeWidth) range:NSMakeRange(0, titleString.length)];
            self.titleLabel.attributedText = attributedString;
            self.maskTitleLabel.attributedText = attributedString;
        }
    }else {
        self.titleLabel.attributedText = attributedString;
        self.maskTitleLabel.attributedText = attributedString;
    }

    if (myItem.isTitleLabelMaskEnabled) {
        self.maskTitleLabel.hidden = NO;
        self.titleLabel.textColor = myItem.titleNormalColor;
        self.maskTitleLabel.textColor = myItem.titleSelectedColor;
        [self.contentView setNeedsLayout];
        [self.contentView layoutIfNeeded];

        CGRect topMaskframe = myItem.backgroundViewMaskFrame;
        //将相对于cell的backgroundViewMaskFrame转换为相对于maskTitleLabel
        //使用self.bounds.size.width而不是self.contentView.bounds.size.width。因为某些情况下，会出现self.bounds是正确的，而self.contentView.bounds还是重用前的状态。
        topMaskframe.origin.y = 0;
        CGRect bottomMaskFrame = topMaskframe;
        CGFloat maskStartX = 0;
        if (self.maskTitleLabel.bounds.size.width >= self.bounds.size.width) {
            topMaskframe.origin.x -= (self.maskTitleLabel.bounds.size.width -self.bounds.size.width)/2;
            bottomMaskFrame.size.width = self.maskTitleLabel.bounds.size.width;
            maskStartX = -(self.maskTitleLabel.bounds.size.width -self.bounds.size.width)/2;
        }else {
            bottomMaskFrame.size.width = self.bounds.size.width;
            topMaskframe.origin.x -= (self.bounds.size.width -self.maskTitleLabel.bounds.size.width)/2;
            maskStartX = 0;
        }
        bottomMaskFrame.origin.x = topMaskframe.origin.x;
        if (topMaskframe.origin.x > maskStartX) {
            bottomMaskFrame.origin.x = topMaskframe.origin.x - bottomMaskFrame.size.width;
        }else {
            bottomMaskFrame.origin.x = CGRectGetMaxX(topMaskframe);
        }

        [CATransaction begin];
        [CATransaction setDisableActions:YES];
        if (topMaskframe.size.width > 0 && CGRectIntersectsRect(topMaskframe, self.maskTitleLabel.frame)) {
            self.titleLabel.layer.mask = self.titleMaskLayer;
            self.maskTitleMaskLayer.frame = topMaskframe;
            self.titleMaskLayer.frame = bottomMaskFrame;
        }else {
            self.maskTitleMaskLayer.frame = topMaskframe;
            self.titleLabel.layer.mask = nil;
        }
        [CATransaction commit];
    }else {
        self.maskTitleLabel.hidden = YES;
        self.titleLabel.layer.mask = nil;
        if (myItem.isSelectedAnimationEnabled && [self checkCanStartSelectedAnimation:myItem]) {
            BZMPageMenuCellSelectedAnimationBlock block = [self preferredTitleColorAnimationBlock:myItem];
            [self addSelectedAnimationBlock:block];
        }else {
           self.titleLabel.textColor = myItem.titleCurrentColor;
        }
    }

    [self startSelectedAnimationIfNeeded:myItem];
}

- (BZMPageMenuCellSelectedAnimationBlock)preferredTitleZoomAnimationBlock:(BZMPageMenuTitleItem *)item baseScale:(CGFloat)baseScale {
    __weak typeof(self) weakSelf = self;
    return ^(CGFloat percent) {
        if (item.isSelected) {
            //将要选中，scale从小到大插值渐变
            item.titleLabelCurrentZoomScale = [BZMPageFactory interpolationFrom:item.titleLabelNormalZoomScale to:item.titleLabelSelectedZoomScale percent:percent];
        }else {
            //将要取消选中，scale从大到小插值渐变
            item.titleLabelCurrentZoomScale = [BZMPageFactory interpolationFrom:item.titleLabelSelectedZoomScale to:item.titleLabelNormalZoomScale percent:percent];
        }
        CGAffineTransform currentTransform = CGAffineTransformMakeScale(baseScale*item.titleLabelCurrentZoomScale, baseScale*item.titleLabelCurrentZoomScale);
        weakSelf.titleLabel.transform = currentTransform;
        weakSelf.maskTitleLabel.transform = currentTransform;
    };
}

- (BZMPageMenuCellSelectedAnimationBlock)preferredTitleStrokeWidthAnimationBlock:(BZMPageMenuTitleItem *)item attributedString:(NSMutableAttributedString *)attributedString {
    __weak typeof(self) weakSelf = self;
    return ^(CGFloat percent) {
        if (item.isSelected) {
            //将要选中，StrokeWidth从小到大插值渐变
            item.titleLabelCurrentStrokeWidth = [BZMPageFactory interpolationFrom:item.titleLabelNormalStrokeWidth to:item.titleLabelSelectedStrokeWidth percent:percent];
        }else {
            //将要取消选中，StrokeWidth从大到小插值渐变
            item.titleLabelCurrentStrokeWidth = [BZMPageFactory interpolationFrom:item.titleLabelSelectedStrokeWidth to:item.titleLabelNormalStrokeWidth percent:percent];
        }
        [attributedString addAttribute:NSStrokeWidthAttributeName value:@(item.titleLabelCurrentStrokeWidth) range:NSMakeRange(0, attributedString.string.length)];
        weakSelf.titleLabel.attributedText = attributedString;
        weakSelf.maskTitleLabel.attributedText = attributedString;
    };
}

- (BZMPageMenuCellSelectedAnimationBlock)preferredTitleColorAnimationBlock:(BZMPageMenuTitleItem *)item {
    __weak typeof(self) weakSelf = self;
    return ^(CGFloat percent) {
        if (item.isSelected) {
            //将要选中，textColor从titleNormalColor到titleSelectedColor插值渐变
            item.titleCurrentColor = [BZMPageFactory interpolationColorFrom:item.titleNormalColor to:item.titleSelectedColor percent:percent];
        }else {
            //将要取消选中，textColor从titleSelectedColor到titleNormalColor插值渐变
            item.titleCurrentColor = [BZMPageFactory interpolationColorFrom:item.titleSelectedColor to:item.titleNormalColor percent:percent];
        }
        weakSelf.titleLabel.textColor = item.titleCurrentColor;
    };
}

@end

