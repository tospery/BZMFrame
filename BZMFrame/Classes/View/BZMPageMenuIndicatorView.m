//
//  BZMPageMenuIndicatorView.m
//  Pods
//
//  Created by 杨建祥 on 2020/1/10.
//

#import "BZMPageMenuIndicatorView.h"
#import "BZMPageFactory.h"
#import "BZMPageMenuIndicatorBackgroundView.h"

@interface BZMPageMenuIndicatorView()

@end

@implementation BZMPageMenuIndicatorView

- (void)didInitialize {
    [super didInitialize];

    _separatorLineShowEnabled = NO;
    _separatorLineColor = [UIColor lightGrayColor];
    _separatorLineSize = CGSizeMake(1/[UIScreen mainScreen].scale, 20);
    _cellBackgroundColorGradientEnabled = NO;
    _cellBackgroundUnselectedColor = [UIColor whiteColor];
    _cellBackgroundSelectedColor = [UIColor lightGrayColor];
}

- (void)setIndicators:(NSArray<UIView<BZMPageMenuIndicator> *> *)indicators {
    _indicators = indicators;

    self.collectionView.indicators = indicators;
}

- (void)refreshState {
    [super refreshState];

    CGRect selectedCellFrame = CGRectZero;
    BZMPageMenuIndicatorItem *selectedItem = nil;
    for (int i = 0; i < self.dataSource.count; i++) {
        BZMPageMenuIndicatorItem *item = (BZMPageMenuIndicatorItem *)self.dataSource[i];
        item.sepratorLineShowEnabled = self.isSeparatorLineShowEnabled;
        item.separatorLineColor = self.separatorLineColor;
        item.separatorLineSize = self.separatorLineSize;
        item.backgroundViewMaskFrame = CGRectZero;
        item.cellBackgroundColorGradientEnabled = self.isCellBackgroundColorGradientEnabled;
        item.cellBackgroundSelectedColor = self.cellBackgroundSelectedColor;
        item.cellBackgroundUnselectedColor = self.cellBackgroundUnselectedColor;
        if (i == self.dataSource.count - 1) {
            item.sepratorLineShowEnabled = NO;
        }
        if (i == self.selectedIndex) {
            selectedItem = item;
            selectedCellFrame = [self getTargetCellFrame:i];
        }
    }

    for (UIView<BZMPageMenuIndicator> *indicator in self.indicators) {
        if (self.dataSource.count <= 0) {
            indicator.hidden = YES;
        }else {
            indicator.hidden = NO;
            BZMPageMenuIndicatorModel *indicatorParamsModel = [[BZMPageMenuIndicatorModel alloc] init];
            indicatorParamsModel.selectedIndex = self.selectedIndex;
            indicatorParamsModel.selectedCellFrame = selectedCellFrame;
            [indicator refreshState:indicatorParamsModel];

            if ([indicator isKindOfClass:[BZMPageMenuIndicatorBackgroundView class]]) {
                CGRect maskFrame = indicator.frame;
                maskFrame.origin.x = maskFrame.origin.x - selectedCellFrame.origin.x;
                selectedItem.backgroundViewMaskFrame = maskFrame;
            }
        }
    }
}

- (void)refreshSelectedItem:(BZMPageMenuItem *)selectedItem unselectedItem:(BZMPageMenuItem *)unselectedItem {
    [super refreshSelectedItem:selectedItem unselectedItem:unselectedItem];

    BZMPageMenuIndicatorItem *myUnselectedItem = (BZMPageMenuIndicatorItem *)unselectedItem;
    myUnselectedItem.backgroundViewMaskFrame = CGRectZero;
    myUnselectedItem.cellBackgroundUnselectedColor = self.cellBackgroundUnselectedColor;
    myUnselectedItem.cellBackgroundSelectedColor = self.cellBackgroundSelectedColor;

    BZMPageMenuIndicatorItem *myselectedItem = (BZMPageMenuIndicatorItem *)selectedItem;
    myselectedItem.cellBackgroundUnselectedColor = self.cellBackgroundUnselectedColor;
    myselectedItem.cellBackgroundSelectedColor = self.cellBackgroundSelectedColor;
}

- (void)contentOffsetOfContentScrollViewDidChanged:(CGPoint)contentOffset {
    [super contentOffsetOfContentScrollViewDidChanged:contentOffset];
    
    CGFloat ratio = contentOffset.x/self.contentScrollView.bounds.size.width;
    if (ratio > self.dataSource.count - 1 || ratio < 0) {
        //超过了边界，不需要处理
        return;
    }
    ratio = MAX(0, MIN(self.dataSource.count - 1, ratio));
    NSInteger baseIndex = floorf(ratio);
    if (baseIndex + 1 >= self.dataSource.count) {
        //右边越界了，不需要处理
        return;
    }
    CGFloat remainderRatio = ratio - baseIndex;

    CGRect leftCellFrame = [self getTargetCellFrame:baseIndex];
    CGRect rightCellFrame = [self getTargetCellFrame:baseIndex + 1];

    BZMPageMenuIndicatorModel *indicatorParamsModel = [[BZMPageMenuIndicatorModel alloc] init];
    indicatorParamsModel.selectedIndex = self.selectedIndex;
    indicatorParamsModel.leftIndex = baseIndex;
    indicatorParamsModel.leftCellFrame = leftCellFrame;
    indicatorParamsModel.rightIndex = baseIndex + 1;
    indicatorParamsModel.rightCellFrame = rightCellFrame;
    indicatorParamsModel.percent = remainderRatio;
    if (remainderRatio == 0) {
        for (UIView<BZMPageMenuIndicator> *indicator in self.indicators) {
            [indicator contentScrollViewDidScroll:indicatorParamsModel];
        }
    }else {
        BZMPageMenuIndicatorItem *leftItem = (BZMPageMenuIndicatorItem *)self.dataSource[baseIndex];
        leftItem.selectedType = BZMPageMenuCellSelectedTypeUnknown;
        BZMPageMenuIndicatorItem *rightItem = (BZMPageMenuIndicatorItem *)self.dataSource[baseIndex + 1];
        rightItem.selectedType = BZMPageMenuCellSelectedTypeUnknown;
        [self refreshLeftItem:leftItem rightItem:rightItem ratio:remainderRatio];

        for (UIView<BZMPageMenuIndicator> *indicator in self.indicators) {
            [indicator contentScrollViewDidScroll:indicatorParamsModel];
            if ([indicator isKindOfClass:[BZMPageMenuIndicatorBackgroundView class]]) {
                CGRect leftMaskFrame = indicator.frame;
                leftMaskFrame.origin.x = leftMaskFrame.origin.x - leftCellFrame.origin.x;
                leftItem.backgroundViewMaskFrame = leftMaskFrame;

                CGRect rightMaskFrame = indicator.frame;
                rightMaskFrame.origin.x = rightMaskFrame.origin.x - rightCellFrame.origin.x;
                rightItem.backgroundViewMaskFrame = rightMaskFrame;
            }
        }

        BZMPageMenuCell *leftCell = (BZMPageMenuCell *)[self.collectionView cellForItemAtIndexPath:[NSIndexPath indexPathForItem:baseIndex inSection:0]];
        [leftCell bindViewModel:leftItem];
        BZMPageMenuCell *rightCell = (BZMPageMenuCell *)[self.collectionView cellForItemAtIndexPath:[NSIndexPath indexPathForItem:baseIndex + 1 inSection:0]];
        [rightCell bindViewModel:rightItem];
    }
}

- (BOOL)selectCellAtIndex:(NSInteger)index selectedType:(BZMPageMenuCellSelectedType)selectedType {
    NSInteger lastSelectedIndex = self.selectedIndex;
    BOOL result = [super selectCellAtIndex:index selectedType:selectedType];
    if (!result) {
        return NO;
    }

    CGRect clickedCellFrame = [self getTargetSelectedCellFrame:index selectedType:selectedType];
    
    BZMPageMenuIndicatorItem *selectedItem = (BZMPageMenuIndicatorItem *)self.dataSource[index];
    selectedItem.selectedType = selectedType;
    for (UIView<BZMPageMenuIndicator> *indicator in self.indicators) {
        BZMPageMenuIndicatorModel *indicatorParamsModel = [[BZMPageMenuIndicatorModel alloc] init];
        indicatorParamsModel.lastSelectedIndex = lastSelectedIndex;
        indicatorParamsModel.selectedIndex = index;
        indicatorParamsModel.selectedCellFrame = clickedCellFrame;
        indicatorParamsModel.selectedType = selectedType;
        [indicator selectedCell:indicatorParamsModel];
        if ([indicator isKindOfClass:[BZMPageMenuIndicatorBackgroundView class]]) {
            CGRect maskFrame = indicator.frame;
            maskFrame.origin.x = maskFrame.origin.x - clickedCellFrame.origin.x;
            selectedItem.backgroundViewMaskFrame = maskFrame;
        }
    }

    BZMPageMenuIndicatorCell *selectedCell = (BZMPageMenuIndicatorCell *)[self.collectionView cellForItemAtIndexPath:[NSIndexPath indexPathForItem:index inSection:0]];
    [selectedCell bindViewModel:selectedItem];

    return YES;
}

@end

@implementation BZMPageMenuIndicatorView (UISubclassingIndicatorHooks)

- (void)refreshLeftItem:(BZMPageMenuItem *)leftItem rightItem:(BZMPageMenuItem *)rightItem ratio:(CGFloat)ratio {
    if (self.isCellBackgroundColorGradientEnabled) {
        //处理cell背景色渐变
        BZMPageMenuIndicatorItem *leftModel = (BZMPageMenuIndicatorItem *)leftItem;
        BZMPageMenuIndicatorItem *rightModel = (BZMPageMenuIndicatorItem *)rightItem;
        if (leftModel.isSelected) {
            leftModel.cellBackgroundSelectedColor = [BZMPageFactory interpolationColorFrom:self.cellBackgroundSelectedColor to:self.cellBackgroundUnselectedColor percent:ratio];
            leftModel.cellBackgroundUnselectedColor = self.cellBackgroundUnselectedColor;
        }else {
            leftModel.cellBackgroundUnselectedColor = [BZMPageFactory interpolationColorFrom:self.cellBackgroundSelectedColor to:self.cellBackgroundUnselectedColor percent:ratio];
            leftModel.cellBackgroundSelectedColor = self.cellBackgroundSelectedColor;
        }
        if (rightModel.isSelected) {
            rightModel.cellBackgroundSelectedColor = [BZMPageFactory interpolationColorFrom:self.cellBackgroundUnselectedColor to:self.cellBackgroundSelectedColor percent:ratio];
            rightModel.cellBackgroundUnselectedColor = self.cellBackgroundUnselectedColor;
        }else {
            rightModel.cellBackgroundUnselectedColor = [BZMPageFactory interpolationColorFrom:self.cellBackgroundUnselectedColor to:self.cellBackgroundSelectedColor percent:ratio];
            rightModel.cellBackgroundSelectedColor = self.cellBackgroundSelectedColor;
        }
    }

}

@end
