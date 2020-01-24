//
//  BZMPageMenuView.m
//  Pods
//
//  Created by 杨建祥 on 2020/1/10.
//

#import "BZMPageMenuView.h"
#import "BZMFunction.h"
#import "BZMPageFactory.h"
#import "BZMPageMenuAnimator.h"

struct DelegateFlags {
    unsigned int didSelectedItemAtIndexFlag : 1;
    unsigned int didClickSelectedItemAtIndexFlag : 1;
    unsigned int didScrollSelectedItemAtIndexFlag : 1;
    unsigned int canClickItemAtIndexFlag : 1;
    unsigned int scrollingFromLeftIndexToRightIndexFlag : 1;
};

@interface BZMPageMenuView () <UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout>

@property (nonatomic, strong) BZMPageMenuCollectionView *collectionView;
@property (nonatomic, assign) struct DelegateFlags delegateFlags;
@property (nonatomic, assign) NSInteger selectedIndex;
@property (nonatomic, assign) CGFloat innerCellSpacing;
@property (nonatomic, assign) CGPoint lastContentViewContentOffset;
@property (nonatomic, strong) BZMPageMenuAnimator *animator;
// 正在滚动中的目标index。用于处理正在滚动列表的时候，立即点击item，会导致界面显示异常。
@property (nonatomic, assign) NSInteger scrollingTargetIndex;
@property (nonatomic, assign, getter=isNeedReloadByBecomeActive) BOOL needReloadByBecomeActive;
@property (nonatomic, assign, getter=isFirstLayoutSubviews) BOOL firstLayoutSubviews;

@end

@implementation BZMPageMenuView

- (void)dealloc
{
    if (self.contentScrollView) {
        [self.contentScrollView removeObserver:self forKeyPath:@"contentOffset"];
    }
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIApplicationDidBecomeActiveNotification object:nil];
    [self.animator stop];
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self didInitialize];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        [self didInitialize];
    }
    return self;
}

- (void)willMoveToSuperview:(UIView *)newSuperview {
    [super willMoveToSuperview:newSuperview];

    UIResponder *next = newSuperview;
    while (next != nil) {
        if ([next isKindOfClass:[UIViewController class]]) {
            ((UIViewController *)next).automaticallyAdjustsScrollViewInsets = NO;
            break;
        }
        next = next.nextResponder;
    }
}

- (void)reloadData {
    [self reloadDataWithoutListContainer];
    [self.containerView reloadData];
}

- (void)reloadDataWithoutListContainer {
    [self refreshDataSource];
    [self refreshState];
    [self.collectionView.collectionViewLayout invalidateLayout];
    [self.collectionView reloadData];
}

- (void)reloadCellAtIndex:(NSInteger)index {
    if (index < 0 || index >= self.dataSource.count) {
        return;
    }
    BZMPageMenuItem *item = self.dataSource[index];
    item.selectedType = BZMPageMenuCellSelectedTypeUnknown;
    [self refreshItem:item index:index];
    BZMPageMenuCell *cell = (BZMPageMenuCell *)[self.collectionView cellForItemAtIndexPath:[NSIndexPath indexPathForItem:index inSection:0]];
    [cell bindViewModel:item];
}

- (void)selectItemAtIndex:(NSInteger)index {
    [self selectCellAtIndex:index selectedType:BZMPageMenuCellSelectedTypeCode];
}

- (void)layoutSubviews
{
    [super layoutSubviews];

    //部分使用者为了适配不同的手机屏幕尺寸，BZMCategoryView的宽高比要求保持一样，所以它的高度就会因为不同宽度的屏幕而不一样。计算出来的高度，有时候会是位数很长的浮点数，如果把这个高度设置给UICollectionView就会触发内部的一个错误。所以，为了规避这个问题，在这里对高度统一向下取整。
    //如果向下取整导致了你的页面异常，请自己重新设置BZMCategoryView的高度，保证为整数即可。
    CGRect targetFrame = CGRectMake(0, 0, self.bounds.size.width, floor(self.bounds.size.height));
    if (self.isFirstLayoutSubviews) {
        self.firstLayoutSubviews = NO;
        self.collectionView.frame = targetFrame;
        [self reloadDataWithoutListContainer];
    }else {
        if (!CGRectEqualToRect(self.collectionView.frame, targetFrame)) {
            self.collectionView.frame = targetFrame;
            [self.collectionView.collectionViewLayout invalidateLayout];
            [self.collectionView reloadData];
        }
    }
}

#pragma mark - Setter

- (void)setDelegate:(id<BZMPageMenuViewDelegate>)delegate {
    _delegate = delegate;

    _delegateFlags.didSelectedItemAtIndexFlag = [delegate respondsToSelector:@selector(menuView:didSelectedItemAtIndex:)];
    _delegateFlags.didClickSelectedItemAtIndexFlag = [delegate respondsToSelector:@selector(menuView:didClickSelectedItemAtIndex:)];
    _delegateFlags.didScrollSelectedItemAtIndexFlag = [delegate respondsToSelector:@selector(menuView:didScrollSelectedItemAtIndex:)];
    _delegateFlags.canClickItemAtIndexFlag = [delegate respondsToSelector:@selector(menuView:canClickItemAtIndex:)];
    _delegateFlags.scrollingFromLeftIndexToRightIndexFlag = [delegate respondsToSelector:@selector(menuView:scrollingFromLeftIndex:toRightIndex:ratio:)];
}

- (void)setDefaultSelectedIndex:(NSInteger)defaultSelectedIndex
{
    _defaultSelectedIndex = defaultSelectedIndex;

    self.selectedIndex = defaultSelectedIndex;
    [self.containerView setDefaultSelectedIndex:defaultSelectedIndex];
}

- (void)setContentScrollView:(UIScrollView *)contentScrollView
{
    if (_contentScrollView != nil) {
        [_contentScrollView removeObserver:self forKeyPath:@"contentOffset"];
    }
    _contentScrollView = contentScrollView;

    self.contentScrollView.scrollsToTop = NO;
    [self.contentScrollView addObserver:self forKeyPath:@"contentOffset" options:NSKeyValueObservingOptionNew context:nil];
}

- (void)setContainerView:(id<BZMPageContainerProtocol>)containerView {
    _containerView = containerView;
    [containerView setDefaultSelectedIndex:self.defaultSelectedIndex];
    self.contentScrollView = [containerView contentScrollView];
}

#pragma mark - <UICollectionViewDataSource, UICollectionViewDelegate>

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.dataSource.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    return [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([self preferredCellClass]) forIndexPath:indexPath];
}

- (void)collectionView:(UICollectionView *)collectionView willDisplayCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath {
    BZMPageMenuItem *item = self.dataSource[indexPath.item];
    item.selectedType = BZMPageMenuCellSelectedTypeUnknown;
    [(BZMPageMenuCell *)cell bindViewModel:item];
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    BOOL isTransitionAnimating = NO;
    for (BZMPageMenuItem *item in self.dataSource) {
        if (item.isTransitionAnimating) {
            isTransitionAnimating = YES;
            break;
        }
    }
    if (!isTransitionAnimating) {
        //当前没有正在过渡的item，才允许点击选中
        [self clickSelectItemAtIndex:indexPath.row];
    }
}

#pragma mark - <UICollectionViewDelegateFlowLayout>

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsMake(0, [self getContentEdgeInsetLeft], 0, [self getContentEdgeInsetRight]);
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake(self.dataSource[indexPath.item].cellWidth, self.collectionView.bounds.size.height);
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    return self.innerCellSpacing;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    return self.innerCellSpacing;
}

#pragma mark - KVO

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context {
    if ([keyPath isEqualToString:@"contentOffset"]) {
        CGPoint contentOffset = [change[NSKeyValueChangeNewKey] CGPointValue];
        if ((self.contentScrollView.isTracking || self.contentScrollView.isDecelerating)) {
            //只处理用户滚动的情况
            [self contentOffsetOfContentScrollViewDidChanged:contentOffset];
        }
        self.lastContentViewContentOffset = contentOffset;
    }
}

#pragma mark - Private

- (CGFloat)getContentEdgeInsetLeft {
    if (self.contentEdgeInsetLeft == BZMPageAutomaticDimension) {
        return self.innerCellSpacing;
    }
    return self.contentEdgeInsetLeft;
}

- (CGFloat)getContentEdgeInsetRight {
    if (self.contentEdgeInsetRight == BZMPageAutomaticDimension) {
        return self.innerCellSpacing;
    }
    return self.contentEdgeInsetRight;
}

- (CGFloat)getCellWidthAtIndex:(NSInteger)index {
    return [self preferredCellWidthAtIndex:index] + self.cellWidthIncrement;
}

- (void)clickSelectItemAtIndex:(NSInteger)index {
    if (self.delegateFlags.canClickItemAtIndexFlag && ![self.delegate menuView:self canClickItemAtIndex:index]) {
        return;
    }

    [self selectCellAtIndex:index selectedType:BZMPageMenuCellSelectedTypeClick];
}

- (void)scrollSelectItemAtIndex:(NSInteger)index {
    [self selectCellAtIndex:index selectedType:BZMPageMenuCellSelectedTypeScroll];
}

- (void)applicationDidBecomeActive:(NSNotification *)notification {
    if (self.isNeedReloadByBecomeActive) {
        self.needReloadByBecomeActive = NO;
        [self reloadData];
    }
}

@end

@implementation BZMPageMenuView (UISubclassingBaseHooks)

- (CGRect)getTargetCellFrame:(NSInteger)targetIndex
{
    CGFloat x = [self getContentEdgeInsetLeft];
    for (int i = 0; i < targetIndex; i ++) {
        BZMPageMenuItem *item = self.dataSource[i];
        CGFloat cellWidth;
        if (item.isTransitionAnimating && item.isCellWidthZoomEnabled) {
            //正在进行动画的时候，cellWidthCurrentZoomScale是随着动画渐变的，而没有立即更新到目标值
            if (item.isSelected) {
                cellWidth = [self getCellWidthAtIndex:item.index]*item.cellWidthSelectedZoomScale;
            }else {
                cellWidth = [self getCellWidthAtIndex:item.index]*item.cellWidthNormalZoomScale;
            }
        }else {
            cellWidth = item.cellWidth;
        }
        x += cellWidth + self.innerCellSpacing;
    }
    CGFloat width;
    BZMPageMenuItem *selectedItem = self.dataSource[targetIndex];
    if (selectedItem.isTransitionAnimating && selectedItem.isCellWidthZoomEnabled) {
        width = [self getCellWidthAtIndex:selectedItem.index]*selectedItem.cellWidthSelectedZoomScale;
    }else {
        width = selectedItem.cellWidth;
    }
    return CGRectMake(x, 0, width, self.bounds.size.height);
}

- (CGRect)getTargetSelectedCellFrame:(NSInteger)targetIndex selectedType:(BZMPageMenuCellSelectedType)selectedType
{
    CGFloat x = [self getContentEdgeInsetLeft];
    for (int i = 0; i < targetIndex; i ++) {
        BZMPageMenuItem *item = self.dataSource[i];
        x += [self getCellWidthAtIndex:item.index] + self.innerCellSpacing;
    }
    CGFloat cellWidth = 0;
    BZMPageMenuItem *selectedItem = self.dataSource[targetIndex];
    if (selectedItem.cellWidthZoomEnabled) {
        cellWidth = [self getCellWidthAtIndex:targetIndex]*selectedItem.cellWidthSelectedZoomScale;
    }else {
        cellWidth = [self getCellWidthAtIndex:targetIndex];
    }
    return CGRectMake(x, 0, cellWidth, self.bounds.size.height);
}

- (void)didInitialize {
    // Data
    _firstLayoutSubviews = YES;
    _dataSource = [NSMutableArray array];
    _selectedIndex = 0;
    _cellWidth = BZMPageAutomaticDimension;
    _cellWidthIncrement = 0;
    _cellSpacing = 20;
    _averageCellSpacingEnabled = YES;
    _cellWidthZoomEnabled = NO;
    _cellWidthZoomScale = 1.2;
    _cellWidthZoomScrollGradientEnabled = YES;
    _contentEdgeInsetLeft = BZMPageAutomaticDimension;
    _contentEdgeInsetRight = BZMPageAutomaticDimension;
    _lastContentViewContentOffset = CGPointZero;
    _selectedAnimationEnabled = NO;
    _selectedAnimationDuration = 0.25;
    _scrollingTargetIndex = -1;
    _contentScrollViewClickTransitionAnimationEnabled = YES;
    _needReloadByBecomeActive = NO;
    
    // View
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    _collectionView = [[BZMPageMenuCollectionView alloc] initWithFrame:self.bounds collectionViewLayout:layout];
    self.collectionView.backgroundColor = [UIColor clearColor];
    self.collectionView.showsHorizontalScrollIndicator = NO;
    self.collectionView.showsVerticalScrollIndicator = NO;
    self.collectionView.scrollsToTop = NO;
    self.collectionView.dataSource = self;
    self.collectionView.delegate = self;
    [self.collectionView registerClass:[self preferredCellClass] forCellWithReuseIdentifier:NSStringFromClass([self preferredCellClass])];
    if (@available(iOS 10.0, *)) {
        self.collectionView.prefetchingEnabled = NO;
    }
    if (@available(iOS 11.0, *)) {
        self.collectionView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    }
    [self addSubview:self.collectionView];

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applicationDidBecomeActive:) name:UIApplicationDidBecomeActiveNotification object:nil];
}

- (void)refreshDataSource {

}

- (void)refreshState {
    if (self.selectedIndex < 0 || self.selectedIndex >= self.dataSource.count) {
        self.selectedIndex = 0;
    }

    self.innerCellSpacing = self.cellSpacing;
    //总的内容宽度（左边距+cell总宽度+总cellSpacing+右边距）
    __block CGFloat totalItemWidth = [self getContentEdgeInsetLeft];
    //总的cell宽度
    CGFloat totalCellWidth = 0;
    for (int i = 0; i < self.dataSource.count; i++) {
        BZMPageMenuItem *item = self.dataSource[i];
        item.index = i;
        item.cellWidthZoomEnabled = self.cellWidthZoomEnabled;
        item.cellWidthNormalZoomScale = 1;
        item.cellWidthSelectedZoomScale = self.cellWidthZoomScale;
        item.selectedAnimationEnabled = self.selectedAnimationEnabled;
        item.selectedAnimationDuration = self.selectedAnimationDuration;
        item.cellSpacing = self.innerCellSpacing;
        if (i == self.selectedIndex) {
            item.selected = YES;
            item.cellWidthCurrentZoomScale = item.cellWidthSelectedZoomScale;
        }else {
            item.selected = NO;
            item.cellWidthCurrentZoomScale = item.cellWidthNormalZoomScale;
        }
        if (self.isCellWidthZoomEnabled) {
            item.cellWidth = [self getCellWidthAtIndex:i]*item.cellWidthCurrentZoomScale;
        }else {
            item.cellWidth = [self getCellWidthAtIndex:i];
        }
        totalCellWidth += item.cellWidth;
        if (i == self.dataSource.count - 1) {
            totalItemWidth += item.cellWidth + [self getContentEdgeInsetRight];
        }else {
            totalItemWidth += item.cellWidth + self.innerCellSpacing;
        }
        [self refreshItem:item index:i];
    }

    if (self.isAverageCellSpacingEnabled && totalItemWidth < self.bounds.size.width) {
        //如果总的内容宽度都没有超过视图宽度，就将cellSpacing等分
        NSInteger cellSpacingItemCount = self.dataSource.count - 1;
        CGFloat totalCellSpacingWidth = self.bounds.size.width - totalCellWidth;
        //如果内容左边距是Automatic，就加1
        if (self.contentEdgeInsetLeft == BZMPageAutomaticDimension) {
            cellSpacingItemCount += 1;
        }else {
            totalCellSpacingWidth -= self.contentEdgeInsetLeft;
        }
        //如果内容右边距是Automatic，就加1
        if (self.contentEdgeInsetRight == BZMPageAutomaticDimension) {
            cellSpacingItemCount += 1;
        }else {
            totalCellSpacingWidth -= self.contentEdgeInsetRight;
        }

        CGFloat cellSpacing = 0;
        if (cellSpacingItemCount > 0) {
            cellSpacing = totalCellSpacingWidth/cellSpacingItemCount;
        }
        self.innerCellSpacing = cellSpacing;
        [self.dataSource enumerateObjectsUsingBlock:^(BZMPageMenuItem * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            obj.cellSpacing = self.innerCellSpacing;
        }];
    }

    //---------------------定位collectionView到当前选中的位置----------------------
    //因为初始化的时候，collectionView并没有初始化完，cell都没有被加载出来。只有自己手动计算当前选中的index的位置，然后更新到contentOffset
    __block CGFloat frameXOfSelectedCell = self.innerCellSpacing;
    __block CGFloat selectedCellWidth = 0;
    totalItemWidth = [self getContentEdgeInsetLeft];
    [self.dataSource enumerateObjectsUsingBlock:^(BZMPageMenuItem * item, NSUInteger idx, BOOL * _Nonnull stop) {
        if (idx < self.selectedIndex) {
            frameXOfSelectedCell += item.cellWidth + self.innerCellSpacing;
        }else if (idx == self.selectedIndex) {
            selectedCellWidth = item.cellWidth;
        }
        if (idx == self.dataSource.count - 1) {
            totalItemWidth += item.cellWidth + [self getContentEdgeInsetRight];
        }else {
            totalItemWidth += item.cellWidth + self.innerCellSpacing;
        }
    }];

    CGFloat minX = 0;
    CGFloat maxX = totalItemWidth - self.bounds.size.width;
    CGFloat targetX = frameXOfSelectedCell - self.bounds.size.width/2.0 + selectedCellWidth/2.0;
    [self.collectionView setContentOffset:CGPointMake(MAX(MIN(maxX, targetX), minX), 0) animated:NO];
    //---------------------定位collectionView到当前选中的位置----------------------

    if (CGRectEqualToRect(self.contentScrollView.frame, CGRectZero) && self.contentScrollView.superview != nil) {
        //某些情况系统会出现BZMCategoryView先布局，contentScrollView后布局。就会导致下面指定defaultSelectedIndex失效，所以发现contentScrollView的frame为zero时，强行触发其父视图链里面已经有frame的一个父视图的layoutSubviews方法。
        //比如BZMSegmentedListContainerView会将contentScrollView包裹起来使用，该情况需要BZMSegmentedListContainerView.superView触发布局更新
        UIView *parentView = self.contentScrollView.superview;
        while (parentView != nil && CGRectEqualToRect(parentView.frame, CGRectZero)) {
            parentView = parentView.superview;
        }
        [parentView setNeedsLayout];
        [parentView layoutIfNeeded];
    }
    //将contentScrollView的contentOffset定位到当前选中index的位置
    [self.contentScrollView setContentOffset:CGPointMake(self.selectedIndex*self.contentScrollView.bounds.size.width, 0) animated:NO];
}

- (BOOL)selectCellAtIndex:(NSInteger)targetIndex selectedType:(BZMPageMenuCellSelectedType)selectedType {
    if (targetIndex < 0 || targetIndex >= self.dataSource.count) {
        return NO;
    }

    self.needReloadByBecomeActive = NO;
    if (self.selectedIndex == targetIndex) {
        //目标index和当前选中的index相等，就不需要处理后续的选中更新逻辑，只需要回调代理方法即可。
        if (selectedType == BZMPageMenuCellSelectedTypeCode) {
            [self.containerView didClickSelectedItemAtIndex:targetIndex];
        }else if (selectedType == BZMPageMenuCellSelectedTypeClick) {
            [self.containerView didClickSelectedItemAtIndex:targetIndex];
            if (self.delegateFlags.didClickSelectedItemAtIndexFlag) {
                [self.delegate menuView:self didClickSelectedItemAtIndex:targetIndex];
            }
        }else if (selectedType == BZMPageMenuCellSelectedTypeScroll) {
            if (self.delegateFlags.didScrollSelectedItemAtIndexFlag) {
                [self.delegate menuView:self didScrollSelectedItemAtIndex:targetIndex];
            }
        }
        if (self.delegateFlags.didSelectedItemAtIndexFlag) {
            [self.delegate menuView:self didSelectedItemAtIndex:targetIndex];
        }
        self.scrollingTargetIndex = -1;
        return NO;
    }

    //通知子类刷新当前选中的和将要选中的item
    BZMPageMenuItem *lastItem = self.dataSource[self.selectedIndex];
    lastItem.selectedType = selectedType;
    BZMPageMenuItem *selectedItem = self.dataSource[targetIndex];
    selectedItem.selectedType = selectedType;
    [self refreshSelectedItem:selectedItem unselectedItem:lastItem];

    //刷新当前选中的和将要选中的cell
    BZMPageMenuCell *lastCell = (BZMPageMenuCell *)[self.collectionView cellForItemAtIndexPath:[NSIndexPath indexPathForItem:self.selectedIndex inSection:0]];
    [lastCell bindViewModel:lastItem];
    BZMPageMenuCell *selectedCell = (BZMPageMenuCell *)[self.collectionView cellForItemAtIndexPath:[NSIndexPath indexPathForItem:targetIndex inSection:0]];
    [selectedCell bindViewModel:selectedItem];

    if (self.scrollingTargetIndex != -1 && self.scrollingTargetIndex != targetIndex) {
        BZMPageMenuItem *scrollingTargetItem = self.dataSource[self.scrollingTargetIndex];
        scrollingTargetItem.selected = NO;
        scrollingTargetItem.selectedType = selectedType;
        [self refreshSelectedItem:selectedItem unselectedItem:scrollingTargetItem];
        BZMPageMenuCell *scrollingTargetCell = (BZMPageMenuCell *)[self.collectionView cellForItemAtIndexPath:[NSIndexPath indexPathForItem:self.scrollingTargetIndex inSection:0]];
        [scrollingTargetCell bindViewModel:scrollingTargetItem];
    }

    if (self.isCellWidthZoomEnabled) {
        [self.collectionView.collectionViewLayout invalidateLayout];
        //延时为了解决cellwidth变化，点击最后几个cell，scrollToItem会出现位置偏移bu。需要等cellWidth动画渐变结束后再滚动到index的cell位置。
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(self.selectedAnimationDuration * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self.collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:targetIndex inSection:0] atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:YES];
        });
    }else {
        [self.collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:targetIndex inSection:0] atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:YES];
    }

    if (selectedType == BZMPageMenuCellSelectedTypeClick ||
        selectedType == BZMPageMenuCellSelectedTypeCode) {
        [self.contentScrollView setContentOffset:CGPointMake(targetIndex*self.contentScrollView.bounds.size.width, 0) animated:self.isContentScrollViewClickTransitionAnimationEnabled];
    }

    self.selectedIndex = targetIndex;
    if (selectedType == BZMPageMenuCellSelectedTypeCode) {
        [self.containerView didClickSelectedItemAtIndex:targetIndex];
    }else if (selectedType == BZMPageMenuCellSelectedTypeClick) {
        [self.containerView didClickSelectedItemAtIndex:targetIndex];
        if (self.delegateFlags.didClickSelectedItemAtIndexFlag) {
            [self.delegate menuView:self didClickSelectedItemAtIndex:targetIndex];
        }
    }else if(selectedType == BZMPageMenuCellSelectedTypeScroll) {
        if (self.delegateFlags.didScrollSelectedItemAtIndexFlag) {
            [self.delegate menuView:self didScrollSelectedItemAtIndex:targetIndex];
        }
    }
    if (self.delegateFlags.didSelectedItemAtIndexFlag) {
        [self.delegate menuView:self didSelectedItemAtIndex:targetIndex];
    }
    self.scrollingTargetIndex = -1;

    return YES;
}


- (void)refreshSelectedItem:(BZMPageMenuItem *)selectedItem unselectedItem:(BZMPageMenuItem *)unselectedItem {
    selectedItem.selected = YES;
    unselectedItem.selected = NO;

    if (self.isCellWidthZoomEnabled) {
        if (selectedItem.selectedType == BZMPageMenuCellSelectedTypeCode ||
            selectedItem.selectedType == BZMPageMenuCellSelectedTypeClick) {
            self.animator = [[BZMPageMenuAnimator alloc] init];
            self.animator.duration = self.selectedAnimationDuration;
            __weak typeof(self) weakSelf = self;
            self.animator.progressCallback = ^(CGFloat percent) {
                selectedItem.transitionAnimating = YES;
                unselectedItem.transitionAnimating = YES;
                selectedItem.cellWidthCurrentZoomScale = [BZMPageFactory interpolationFrom:selectedItem.cellWidthNormalZoomScale to:selectedItem.cellWidthSelectedZoomScale percent:percent];
                selectedItem.cellWidth = [weakSelf getCellWidthAtIndex:selectedItem.index] * selectedItem.cellWidthCurrentZoomScale;
                unselectedItem.cellWidthCurrentZoomScale = [BZMPageFactory interpolationFrom:unselectedItem.cellWidthSelectedZoomScale to:unselectedItem.cellWidthNormalZoomScale percent:percent];
                unselectedItem.cellWidth = [weakSelf getCellWidthAtIndex:unselectedItem.index] * unselectedItem.cellWidthCurrentZoomScale;
                [weakSelf.collectionView.collectionViewLayout invalidateLayout];
            };
            self.animator.completeCallback = ^{
                selectedItem.transitionAnimating = NO;
                unselectedItem.transitionAnimating = NO;
            };
            [self.animator start];
        }else {
            selectedItem.cellWidthCurrentZoomScale = selectedItem.cellWidthSelectedZoomScale;
            selectedItem.cellWidth = [self getCellWidthAtIndex:selectedItem.index] * selectedItem.cellWidthCurrentZoomScale;
            unselectedItem.cellWidthCurrentZoomScale = unselectedItem.cellWidthNormalZoomScale;
            unselectedItem.cellWidth = [self getCellWidthAtIndex:unselectedItem.index] * unselectedItem.cellWidthCurrentZoomScale;
        }
    }
}

- (void)contentOffsetOfContentScrollViewDidChanged:(CGPoint)contentOffset {
    CGFloat ratio = contentOffset.x/self.contentScrollView.bounds.size.width;
    if (ratio > self.dataSource.count - 1 || ratio < 0) {
        //超过了边界，不需要处理
        return;
    }
    if (contentOffset.x == 0 && self.selectedIndex == 0 && self.lastContentViewContentOffset.x == 0) {
        //滚动到了最左边，且已经选中了第一个，且之前的contentOffset.x为0
        return;
    }
    CGFloat maxContentOffsetX = self.contentScrollView.contentSize.width - self.contentScrollView.bounds.size.width;
    if (contentOffset.x == maxContentOffsetX && self.selectedIndex == self.dataSource.count - 1 && self.lastContentViewContentOffset.x == maxContentOffsetX) {
        //滚动到了最右边，且已经选中了最后一个，且之前的contentOffset.x为maxContentOffsetX
        return;
    }
    ratio = MAX(0, MIN(self.dataSource.count - 1, ratio));
    NSInteger baseIndex = floorf(ratio);
    CGFloat remainderRatio = ratio - baseIndex;

    if (remainderRatio == 0) {
        //快速滑动翻页，用户一直在拖拽contentScrollView，需要更新选中状态
        //滑动一小段距离，然后放开回到原位，contentOffset同样的值会回调多次。例如在index为1的情况，滑动放开回到原位，contentOffset会多次回调CGPoint(width, 0)
        if (!(self.lastContentViewContentOffset.x == contentOffset.x && self.selectedIndex == baseIndex)) {
            [self scrollSelectItemAtIndex:baseIndex];
        }
    }else {
        self.needReloadByBecomeActive = YES;
        if (self.animator.isExecuting) {
            [self.animator invalid];
            //需要重置之前animator.progessCallback为处理完的状态
            for (BZMPageMenuItem *model in self.dataSource) {
                if (model.isSelected) {
                    model.cellWidthCurrentZoomScale = model.cellWidthSelectedZoomScale;
                    model.cellWidth = [self getCellWidthAtIndex:model.index] * model.cellWidthCurrentZoomScale;
                }else {
                    model.cellWidthCurrentZoomScale = model.cellWidthNormalZoomScale;
                    model.cellWidth = [self getCellWidthAtIndex:model.index] * model.cellWidthCurrentZoomScale;
                }
            }
        }
        //快速滑动翻页，当remainderRatio没有变成0，但是已经翻页了，需要通过下面的判断，触发选中
        if (fabs(ratio - self.selectedIndex) > 1) {
            NSInteger targetIndex = baseIndex;
            if (ratio < self.selectedIndex) {
                targetIndex = baseIndex + 1;
            }
            [self scrollSelectItemAtIndex:targetIndex];
        }

        if (self.selectedIndex == baseIndex) {
            self.scrollingTargetIndex = baseIndex + 1;
        }else {
            self.scrollingTargetIndex = baseIndex;
        }

        if (self.isCellWidthZoomEnabled && self.isCellWidthZoomScrollGradientEnabled) {
            BZMPageMenuItem *leftItem = (BZMPageMenuItem *)self.dataSource[baseIndex];
            BZMPageMenuItem *rightItem = (BZMPageMenuItem *)self.dataSource[baseIndex + 1];
            leftItem.cellWidthCurrentZoomScale = [BZMPageFactory interpolationFrom:leftItem.cellWidthSelectedZoomScale to:leftItem.cellWidthNormalZoomScale percent:remainderRatio];
            leftItem.cellWidth = [self getCellWidthAtIndex:leftItem.index] * leftItem.cellWidthCurrentZoomScale;
            rightItem.cellWidthCurrentZoomScale = [BZMPageFactory interpolationFrom:rightItem.cellWidthNormalZoomScale to:rightItem.cellWidthSelectedZoomScale percent:remainderRatio];
            rightItem.cellWidth = [self getCellWidthAtIndex:rightItem.index] * rightItem.cellWidthCurrentZoomScale;
            [self.collectionView.collectionViewLayout invalidateLayout];
        }

        [self.containerView scrollingFromLeftIndex:baseIndex toRightIndex:baseIndex + 1 ratio:remainderRatio selectedIndex:self.selectedIndex];
        if (self.delegateFlags.scrollingFromLeftIndexToRightIndexFlag) {
            [self.delegate menuView:self scrollingFromLeftIndex:baseIndex toRightIndex:baseIndex + 1 ratio:remainderRatio];
        }
    }
}

- (CGFloat)preferredCellWidthAtIndex:(NSInteger)index {
    return 0;
}

- (Class)preferredCellClass {
    return BZMPageMenuCell.class;
}

- (void)refreshItem:(BZMPageMenuItem *)item index:(NSInteger)index {

}

@end

