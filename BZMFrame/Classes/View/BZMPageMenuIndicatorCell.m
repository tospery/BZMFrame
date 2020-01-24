//
//  BZMPageMenuIndicatorCell.m
//  Pods
//
//  Created by 杨建祥 on 2020/1/10.
//

#import "BZMPageMenuIndicatorCell.h"
#import "BZMPageMenuIndicatorItem.h"

@interface BZMPageMenuIndicatorCell ()
@property (nonatomic, strong) UIView *separatorLine;

@end

@implementation BZMPageMenuIndicatorCell

- (void)didInitialize
{
    [super didInitialize];

    self.separatorLine = [[UIView alloc] init];
    self.separatorLine.hidden = YES;
    [self.contentView addSubview:self.separatorLine];
}

- (void)layoutSubviews
{
    [super layoutSubviews];

    BZMPageMenuIndicatorItem *model = (BZMPageMenuIndicatorItem *)self.viewModel;
    CGFloat lineWidth = model.separatorLineSize.width;
    CGFloat lineHeight = model.separatorLineSize.height;

    self.separatorLine.frame = CGRectMake(self.bounds.size.width - lineWidth + self.viewModel.cellSpacing/2, (self.bounds.size.height - lineHeight)/2.0, lineWidth, lineHeight);
}

- (void)bindViewModel:(BZMPageMenuItem *)item {
    [super bindViewModel:item];

    BZMPageMenuIndicatorItem *model = (BZMPageMenuIndicatorItem *)item;
    self.separatorLine.backgroundColor = model.separatorLineColor;
    self.separatorLine.hidden = !model.isSepratorLineShowEnabled;

    if (model.isCellBackgroundColorGradientEnabled) {
        if (model.isSelected) {
            self.contentView.backgroundColor = model.cellBackgroundSelectedColor;
        }else {
            self.contentView.backgroundColor = model.cellBackgroundUnselectedColor;
        }
    }
}

@end
