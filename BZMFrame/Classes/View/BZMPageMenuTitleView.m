//
//  BZMPageMenuTitleView.m
//  Pods
//
//  Created by 杨建祥 on 2020/1/10.
//

#import "BZMPageMenuTitleView.h"
#import "BZMFunction.h"
#import "BZMPageFactory.h"

@interface BZMPageMenuTitleView ()

@end

@implementation BZMPageMenuTitleView

- (void)didInitialize
{
    [super didInitialize];

    _titleNumberOfLines = 1;
    _titleLabelZoomEnabled = NO;
    _titleLabelZoomScale = 1.2;
    _titleColor = [UIColor blackColor];
    _titleSelectedColor = [UIColor redColor];
    _titleFont = [UIFont systemFontOfSize:15];
    _titleColorGradientEnabled = NO;
    _titleLabelMaskEnabled = NO;
    _titleLabelZoomScrollGradientEnabled = YES;
    _titleLabelStrokeWidthEnabled = NO;
    _titleLabelSelectedStrokeWidth = -3;
    _titleLabelVerticalOffset = 0;
    _titleLabelAnchorPointStyle = BZMPageMenuTitleLabelAnchorPointStyleCenter;
}

- (UIFont *)titleSelectedFont {
    if (_titleSelectedFont != nil) {
        return _titleSelectedFont;
    }
    return self.titleFont;
}

#pragma mark - Override

- (Class)preferredCellClass {
    return [BZMPageMenuTitleCell class];
}

- (void)refreshDataSource {
    NSMutableArray *tempArray = [NSMutableArray array];
    for (int i = 0; i < self.titles.count; i++) {
        BZMPageMenuTitleItem *item = [[BZMPageMenuTitleItem alloc] initWithModel:nil];
        [tempArray addObject:item];
    }
    self.dataSource = tempArray;
}

- (void)refreshSelectedItem:(BZMPageMenuItem *)selectedItem unselectedItem:(BZMPageMenuItem *)unselectedItem {
    [super refreshSelectedItem:selectedItem unselectedItem:unselectedItem];

    BZMPageMenuTitleItem *myUnselectedItem = (BZMPageMenuTitleItem *)unselectedItem;
    BZMPageMenuTitleItem *myselectedItem = (BZMPageMenuTitleItem *)selectedItem;
    if (self.isSelectedAnimationEnabled) {
        //开启了动画过渡，且cell在屏幕内，current的属性值会在cell里面进行动画插值更新
        //1、当unselectedCell在屏幕外的时候，还是需要在这里更新值
        //2、当selectedCell在屏幕外的时候，还是需要在这里更新值（比如调用selectItemAtIndex方法选中的时候）
        BOOL isUnselectedCellVisible = NO;
        BOOL isSelectedCellVisible = NO;
        NSArray *indexPaths = [self.collectionView indexPathsForVisibleItems];
        for (NSIndexPath *indexPath in indexPaths) {
            if (indexPath.item == myUnselectedItem.index) {
                isUnselectedCellVisible = YES;
                continue;
            }else if (indexPath.item == myselectedItem.index) {
                isSelectedCellVisible = YES;
                continue;
            }
        }
        if (!isUnselectedCellVisible) {
            //但是当unselectedCell在屏幕外时，不会在cell里面通过动画插值更新，在这里直接更新
            myUnselectedItem.titleCurrentColor = myUnselectedItem.titleNormalColor;
            myUnselectedItem.titleLabelCurrentZoomScale = myUnselectedItem.titleLabelNormalZoomScale;
            myUnselectedItem.titleLabelCurrentStrokeWidth = myUnselectedItem.titleLabelNormalStrokeWidth;
        }
        if (!isSelectedCellVisible) {
            //但是当selectedCell在屏幕外时，不会在cell里面通过动画插值更新，在这里直接更新
            myselectedItem.titleCurrentColor = myselectedItem.titleSelectedColor;
            myselectedItem.titleLabelCurrentZoomScale = myselectedItem.titleLabelSelectedZoomScale;
            myselectedItem.titleLabelCurrentStrokeWidth = myselectedItem.titleLabelSelectedStrokeWidth;
        }
    }else {
        //没有开启动画，可以直接更新属性
        myselectedItem.titleCurrentColor = myselectedItem.titleSelectedColor;
        myselectedItem.titleLabelCurrentZoomScale = myselectedItem.titleLabelSelectedZoomScale;
        myselectedItem.titleLabelCurrentStrokeWidth = myselectedItem.titleLabelSelectedStrokeWidth;

        myUnselectedItem.titleCurrentColor = myUnselectedItem.titleNormalColor;
        myUnselectedItem.titleLabelCurrentZoomScale = myUnselectedItem.titleLabelNormalZoomScale;
        myUnselectedItem.titleLabelCurrentStrokeWidth = myUnselectedItem.titleLabelNormalStrokeWidth;
    }
}

- (void)refreshLeftItem:(BZMPageMenuItem *)leftItem rightItem:(BZMPageMenuItem *)rightItem ratio:(CGFloat)ratio {
    [super refreshLeftItem:leftItem rightItem:rightItem ratio:ratio];

    BZMPageMenuTitleItem *leftModel = (BZMPageMenuTitleItem *)leftItem;
    BZMPageMenuTitleItem *rightModel = (BZMPageMenuTitleItem *)rightItem;

    if (self.isTitleLabelZoomEnabled && self.isTitleLabelZoomScrollGradientEnabled) {
        leftModel.titleLabelCurrentZoomScale = [BZMPageFactory interpolationFrom:self.titleLabelZoomScale to:1.0 percent:ratio];
        rightModel.titleLabelCurrentZoomScale = [BZMPageFactory interpolationFrom:1.0 to:self.titleLabelZoomScale percent:ratio];
    }

    if (self.isTitleLabelStrokeWidthEnabled) {
        leftModel.titleLabelCurrentStrokeWidth = [BZMPageFactory interpolationFrom:leftModel.titleLabelSelectedStrokeWidth to:leftModel.titleLabelNormalStrokeWidth percent:ratio];
        rightModel.titleLabelCurrentStrokeWidth = [BZMPageFactory interpolationFrom:rightModel.titleLabelNormalStrokeWidth to:rightModel.titleLabelSelectedStrokeWidth percent:ratio];
    }

    if (self.isTitleColorGradientEnabled) {
        leftModel.titleCurrentColor = [BZMPageFactory interpolationColorFrom:self.titleSelectedColor to:self.titleColor percent:ratio];
        rightModel.titleCurrentColor = [BZMPageFactory interpolationColorFrom:self.titleColor to:self.titleSelectedColor percent:ratio];
    }
}

- (CGFloat)preferredCellWidthAtIndex:(NSInteger)index {
    if (self.cellWidth == BZMPageAutomaticDimension) {
        NSString *title = [self.titles[index] description];
        if (self.titleDataSource && [self.titleDataSource respondsToSelector:@selector(categoryTitleView:widthForTitle:)]) {
            return [self.titleDataSource categoryTitleView:self widthForTitle:title];
        }else {
            return ceilf([title boundingRectWithSize:CGSizeMake(MAXFLOAT, self.bounds.size.height) options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName : self.titleFont} context:nil].size.width);
        }
    }else {
        return self.cellWidth;
    }
}

- (void)refreshItem:(BZMPageMenuItem *)item index:(NSInteger)index {
    [super refreshItem:item index:index];

    BZMPageMenuTitleItem *model = (BZMPageMenuTitleItem *)item;
    model.title = [self.titles[index] description];
    model.titleNumberOfLines = self.titleNumberOfLines;
    model.titleFont = self.titleFont;
    model.titleSelectedFont = self.titleSelectedFont;
    model.titleNormalColor = self.titleColor;
    model.titleSelectedColor = self.titleSelectedColor;
    model.titleLabelMaskEnabled = self.isTitleLabelMaskEnabled;
    model.titleLabelZoomEnabled = self.isTitleLabelZoomEnabled;
    model.titleLabelNormalZoomScale = 1;
    model.titleLabelZoomSelectedVerticalOffset = self.titleLabelZoomSelectedVerticalOffset;
    model.titleLabelSelectedZoomScale = self.titleLabelZoomScale;
    model.titleLabelStrokeWidthEnabled = self.isTitleLabelStrokeWidthEnabled;
    model.titleLabelNormalStrokeWidth = 0;
    model.titleLabelSelectedStrokeWidth = self.titleLabelSelectedStrokeWidth;
    model.titleLabelVerticalOffset = self.titleLabelVerticalOffset;
    model.titleLabelAnchorPointStyle = self.titleLabelAnchorPointStyle;
    if (index == self.selectedIndex) {
        model.titleCurrentColor = model.titleSelectedColor;
        model.titleLabelCurrentZoomScale = model.titleLabelSelectedZoomScale;
        model.titleLabelCurrentStrokeWidth= model.titleLabelSelectedStrokeWidth;
    }else {
        model.titleCurrentColor = model.titleNormalColor;
        model.titleLabelCurrentZoomScale = model.titleLabelNormalZoomScale;
        model.titleLabelCurrentStrokeWidth = model.titleLabelNormalStrokeWidth;
    }
}

@end
