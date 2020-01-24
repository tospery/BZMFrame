//
//  BZMPageContainerView.m
//  Pods
//
//  Created by 杨建祥 on 2020/1/10.
//

#import "BZMPageContainerView.h"
#import <objc/runtime.h>

@interface BZMPageContainerViewController : UIViewController
@property (copy) void(^viewWillAppearBlock)(void);
@property (copy) void(^viewDidAppearBlock)(void);
@property (copy) void(^viewWillDisappearBlock)(void);
@property (copy) void(^viewDidDisappearBlock)(void);

@end

@implementation BZMPageContainerViewController
- (void)dealloc
{
    self.viewWillAppearBlock = nil;
    self.viewDidAppearBlock = nil;
    self.viewWillDisappearBlock = nil;
    self.viewDidDisappearBlock = nil;
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.viewWillAppearBlock();
}
- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    self.viewDidAppearBlock();
}
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    self.viewWillDisappearBlock();
}
- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    self.viewDidDisappearBlock();
}
- (BOOL)shouldAutomaticallyForwardAppearanceMethods { return NO; }
@end

@interface BZMPageContainerView () <UIScrollViewDelegate, UICollectionViewDelegate, UICollectionViewDataSource>
@property (nonatomic, weak) id<BZMPageContainerViewDataSource> dataSource;
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, assign) NSInteger currentIndex;
@property (nonatomic, strong) NSMutableDictionary <NSNumber *, id<BZMPageContentProtocol>> *validContentDict;
@property (nonatomic, assign) NSInteger willAppearIndex;
@property (nonatomic, assign) NSInteger willDisappearIndex;
@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) BZMPageContainerViewController *containerVC;
@end

@implementation BZMPageContainerView

- (instancetype)initWithType:(BZMPageContainerType)type dataSource:(id<BZMPageContainerViewDataSource>)dataSource{
    self = [super initWithFrame:CGRectZero];
    if (self) {
        _containerType = type;
        _dataSource = dataSource;
        _validContentDict = [NSMutableDictionary dictionary];
        _willAppearIndex = -1;
        _willDisappearIndex = -1;
        _contentInitPercent = 0.01;
        [self didInitialize];
    }
    return self;
}

- (void)didInitialize {
    _contentBackgroundColor = [UIColor whiteColor];
    _containerVC = [[BZMPageContainerViewController alloc] init];
    self.containerVC.view.backgroundColor = [UIColor clearColor];
    [self addSubview:self.containerVC.view];
    __weak typeof(self) weakSelf = self;
    self.containerVC.viewWillAppearBlock = ^{
        [weakSelf contentWillAppear:weakSelf.currentIndex];
    };
    self.containerVC.viewDidAppearBlock = ^{
        [weakSelf contentDidAppear:weakSelf.currentIndex];
    };
    self.containerVC.viewWillDisappearBlock = ^{
        [weakSelf contentWillDisappear:weakSelf.currentIndex];
    };
    self.containerVC.viewDidDisappearBlock = ^{
        [weakSelf contentDidDisappear:weakSelf.currentIndex];
    };
    if (self.containerType == BZMPageContainerTypeScrollView) {
        if (self.dataSource &&
            [self.dataSource respondsToSelector:@selector(scrollViewClassInContainerView:)] &&
            [[self.dataSource scrollViewClassInContainerView:self] isKindOfClass:object_getClass([UIScrollView class])]) {
            _scrollView = (UICollectionView *)[[[self.dataSource scrollViewClassInContainerView:self] alloc] init];
        }else {
            _scrollView = [[UIScrollView alloc] init];
        }
        self.scrollView.delegate = self;
        self.scrollView.pagingEnabled = YES;
        self.scrollView.showsHorizontalScrollIndicator = NO;
        self.scrollView.showsVerticalScrollIndicator = NO;
        self.scrollView.scrollsToTop = NO;
        self.scrollView.bounces = NO;
        if (@available(iOS 11.0, *)) {
            self.scrollView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        }
        [self.containerVC.view addSubview:self.scrollView];
    }else {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        layout.minimumLineSpacing = 0;
        layout.minimumInteritemSpacing = 0;
        if (self.dataSource &&
            [self.dataSource respondsToSelector:@selector(scrollViewClassInContainerView:)] &&
            [[self.dataSource scrollViewClassInContainerView:self] isKindOfClass:object_getClass([UICollectionView class])]) {
            _collectionView = (UICollectionView *)[[[self.dataSource scrollViewClassInContainerView:self] alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
        }else {
            _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
        }
        self.collectionView.pagingEnabled = YES;
        self.collectionView.showsHorizontalScrollIndicator = NO;
        self.collectionView.showsVerticalScrollIndicator = NO;
        self.collectionView.scrollsToTop = NO;
        self.collectionView.bounces = NO;
        self.collectionView.dataSource = self;
        self.collectionView.delegate = self;
        [self.collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"cell"];
        if (@available(iOS 10.0, *)) {
            self.collectionView.prefetchingEnabled = NO;
        }
        if (@available(iOS 11.0, *)) {
            self.collectionView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        }
        [self.containerVC.view addSubview:self.collectionView];
        //让外部统一访问scrollView
        _scrollView = _collectionView;
    }
}

- (void)willMoveToSuperview:(UIView *)newSuperview {
    [super willMoveToSuperview:newSuperview];

    UIResponder *next = newSuperview;
    while (next != nil) {
        if ([next isKindOfClass:[UIViewController class]]) {
            [((UIViewController *)next) addChildViewController:self.containerVC];
            break;
        }
        next = next.nextResponder;
    }
}

- (void)layoutSubviews {
    [super layoutSubviews];

    self.containerVC.view.frame = self.bounds;
    if (self.containerType == BZMPageContainerTypeScrollView) {
        if (CGRectEqualToRect(self.scrollView.frame, CGRectZero) ||  !CGSizeEqualToSize(self.scrollView.bounds.size, self.bounds.size)) {
            self.scrollView.frame = self.bounds;
            self.scrollView.contentSize = CGSizeMake(self.scrollView.bounds.size.width*[self.dataSource numberOfContentInContainerView:self], self.scrollView.bounds.size.height);
            [_validContentDict enumerateKeysAndObjectsUsingBlock:^(NSNumber * _Nonnull index, id<BZMPageContentProtocol>  _Nonnull content, BOOL * _Nonnull stop) {
                [content contentView].frame = CGRectMake(index.intValue*self.scrollView.bounds.size.width, 0, self.scrollView.bounds.size.width, self.scrollView.bounds.size.height);
            }];
            self.scrollView.contentOffset = CGPointMake(self.currentIndex*self.scrollView.bounds.size.width, 0);
        }else {
            self.scrollView.frame = self.bounds;
            self.scrollView.contentSize = CGSizeMake(self.scrollView.bounds.size.width*[self.dataSource numberOfContentInContainerView:self], self.scrollView.bounds.size.height);
        }
    }else {
        if (CGRectEqualToRect(self.collectionView.frame, CGRectZero) ||  !CGSizeEqualToSize(self.collectionView.bounds.size, self.bounds.size)) {
            self.collectionView.frame = self.bounds;
            [self.collectionView.collectionViewLayout invalidateLayout];
            [self.collectionView setContentOffset:CGPointMake(self.collectionView.bounds.size.width*self.currentIndex, 0) animated:NO];
        }else {
            self.collectionView.frame = self.bounds;
        }
    }
}


- (void)setContentInitPercent:(CGFloat)contentInitPercent {
    _contentInitPercent = contentInitPercent;
    if (contentInitPercent <= 0 || contentInitPercent >= 1) {
        NSAssert(NO, @"contentInitPercent值范围为开区间(0,1)，即不包括0和1");
    }
}

#pragma mark - UICollectionViewDelegate, UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return [self.dataSource numberOfContentInContainerView:self];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    cell.contentView.backgroundColor = self.contentBackgroundColor;
    for (UIView *subview in cell.contentView.subviews) {
        [subview removeFromSuperview];
    }
    id<BZMPageContentProtocol> content = _validContentDict[@(indexPath.item)];
    if (content != nil) {
        [content contentView].frame = cell.contentView.bounds;
        [cell.contentView addSubview:[content contentView]];
    }
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return self.bounds.size;
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (self.dataSource && [self.dataSource respondsToSelector:@selector(containerViewDidScroll:)]) {
        [self.dataSource containerViewDidScroll:scrollView];
    }
    CGFloat currentIndexPercent = scrollView.contentOffset.x/scrollView.bounds.size.width;
    if (self.willAppearIndex != -1 || self.willDisappearIndex != -1) {
        NSInteger disappearIndex = self.willDisappearIndex;
        NSInteger appearIndex = self.willAppearIndex;
        if (self.willAppearIndex > self.willDisappearIndex) {
            //将要出现的内容在右边
            if (currentIndexPercent >= self.willAppearIndex) {
                self.willDisappearIndex = -1;
                self.willAppearIndex = -1;
                [self contentDidDisappear:disappearIndex];
                [self contentDidAppear:appearIndex];
            }
        }else {
            //将要出现的内容在左边
            if (currentIndexPercent <= self.willAppearIndex) {
                self.willDisappearIndex = -1;
                self.willAppearIndex = -1;
                [self contentDidDisappear:disappearIndex];
                [self contentDidAppear:appearIndex];
            }
        }
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    if (self.willDisappearIndex != -1) {
        [self contentWillAppear:self.willDisappearIndex];
        [self contentWillDisappear:self.willAppearIndex];
        [self contentDidAppear:self.willDisappearIndex];
        [self contentDidDisappear:self.willAppearIndex];
        self.willDisappearIndex = -1;
        self.willAppearIndex = -1;
    }
}

#pragma mark - BZMPageContainerProtocol

- (UIScrollView *)contentScrollView {
    return self.scrollView;
}

- (void)setDefaultSelectedIndex:(NSInteger)index {
    self.currentIndex = index;
}

- (void)scrollingFromLeftIndex:(NSInteger)leftIndex toRightIndex:(NSInteger)rightIndex ratio:(CGFloat)ratio selectedIndex:(NSInteger)selectedIndex {
    if (rightIndex == selectedIndex) {
        //当前选中的在右边，用户正在从右边往左边滑动
        if (ratio < (1 - self.contentInitPercent)) {
            [self initContentIfNeededAtIndex:leftIndex];
        }
        if (self.willAppearIndex == -1) {
            self.willAppearIndex = leftIndex;
            if (self.validContentDict[@(leftIndex)] != nil) {
                [self contentWillAppear:self.willAppearIndex];
            }
        }
        if (self.willDisappearIndex == -1) {
            self.willDisappearIndex = rightIndex;
            [self contentWillDisappear:self.willDisappearIndex];
        }
    }else {
        //当前选中的在左边，用户正在从左边往右边滑动
        if (ratio > self.contentInitPercent) {
            [self initContentIfNeededAtIndex:rightIndex];
        }
        if (self.willAppearIndex == -1) {
            self.willAppearIndex = rightIndex;
            if (_validContentDict[@(rightIndex)] != nil) {
                [self contentWillAppear:self.willAppearIndex];
            }
        }
        if (self.willDisappearIndex == -1) {
            self.willDisappearIndex = leftIndex;
            [self contentWillDisappear:self.willDisappearIndex];
        }
    }
}

- (void)didClickSelectedItemAtIndex:(NSInteger)index {
    if (![self checkIndexValid:index]) {
        return;
    }
    self.willAppearIndex = -1;
    self.willDisappearIndex = -1;
    if (self.currentIndex != index) {
        [self contentWillDisappear:self.currentIndex];
        [self contentDidDisappear:self.currentIndex];
        [self contentWillAppear:index];
        [self contentDidAppear:index];
    }
}

- (void)reloadData {
    for (id<BZMPageContentProtocol> content in _validContentDict.allValues) {
        [[content contentView] removeFromSuperview];
    }
    [_validContentDict removeAllObjects];

    if (self.containerType == BZMPageContainerTypeScrollView) {
        self.scrollView.contentSize = CGSizeMake(self.scrollView.bounds.size.width*[self.dataSource numberOfContentInContainerView:self], self.scrollView.bounds.size.height);
    }else {
        [self.collectionView reloadData];
    }
    [self contentWillAppear:self.currentIndex];
    [self contentDidAppear:self.currentIndex];
}

#pragma mark - Private

- (void)initContentIfNeededAtIndex:(NSInteger)index {
    if (self.dataSource && [self.dataSource respondsToSelector:@selector(containerView:canInitContentAtIndex:)]) {
        BOOL canInitContent = [self.dataSource containerView:self canInitContentAtIndex:index];
        if (!canInitContent) {
            return;
        }
    }
    id<BZMPageContentProtocol> content = _validContentDict[@(index)];
    if (content != nil) {
        //内容已经创建好了
        return;
    }
    content = [self.dataSource containerView:self initContentForIndex:index];
    if ([content isKindOfClass:[UIViewController class]]) {
        [self.containerVC addChildViewController:(UIViewController *)content];
    }
    _validContentDict[@(index)] = content;

    if (self.containerType == BZMPageContainerTypeScrollView) {
        [content contentView].frame = CGRectMake(index*self.scrollView.bounds.size.width, 0, self.scrollView.bounds.size.width, self.scrollView.bounds.size.height);
        [self.scrollView addSubview:[content contentView]];
    }else {
        UICollectionViewCell *cell = [self.collectionView cellForItemAtIndexPath:[NSIndexPath indexPathForItem:index inSection:0]];
        for (UIView *subview in cell.contentView.subviews) {
            [subview removeFromSuperview];
        }
        [content contentView].frame = cell.contentView.bounds;
        [cell.contentView addSubview:[content contentView]];
    }
    [self contentWillAppear:index];
}

- (void)contentWillAppear:(NSInteger)index {
    if (![self checkIndexValid:index]) {
        return;
    }
    id<BZMPageContentProtocol> content = _validContentDict[@(index)];
    if (content != nil) {
        if (content && [content respondsToSelector:@selector(contentWillAppear)]) {
            [content contentWillAppear];
        }
        if ([content isKindOfClass:[UIViewController class]]) {
            UIViewController *contentVC = (UIViewController *)content;
            [contentVC beginAppearanceTransition:YES animated:NO];
        }
    }else {
        //当前内容未被创建（页面初始化或通过点击触发的contentWillAppear）
        BOOL canInitContent = YES;
        if (self.dataSource && [self.dataSource respondsToSelector:@selector(containerView:canInitContentAtIndex:)]) {
            canInitContent = [self.dataSource containerView:self canInitContentAtIndex:index];
        }
        if (canInitContent) {
            id<BZMPageContentProtocol> content = _validContentDict[@(index)];
            if (content == nil) {
                content = [self.dataSource containerView:self initContentForIndex:index];
                if ([content isKindOfClass:[UIViewController class]]) {
                    [self.containerVC addChildViewController:(UIViewController *)content];
                }
                _validContentDict[@(index)] = content;
            }
            if (self.containerType == BZMPageContainerTypeScrollView) {
                if ([content contentView].superview == nil) {
                    [content contentView].frame = CGRectMake(index*self.scrollView.bounds.size.width, 0, self.scrollView.bounds.size.width, self.scrollView.bounds.size.height);
                    [self.scrollView addSubview:[content contentView]];

                    if (content && [content respondsToSelector:@selector(contentWillAppear)]) {
                        [content contentWillAppear];
                    }
                    if ([content isKindOfClass:[UIViewController class]]) {
                        UIViewController *contentVC = (UIViewController *)content;
                        [contentVC beginAppearanceTransition:YES animated:NO];
                    }
                }
            }else {
                UICollectionViewCell *cell = [self.collectionView cellForItemAtIndexPath:[NSIndexPath indexPathForItem:index inSection:0]];
                for (UIView *subview in cell.contentView.subviews) {
                    [subview removeFromSuperview];
                }
                [content contentView].frame = cell.contentView.bounds;
                [cell.contentView addSubview:[content contentView]];

                if (content && [content respondsToSelector:@selector(contentWillAppear)]) {
                    [content contentWillAppear];
                }
                if ([content isKindOfClass:[UIViewController class]]) {
                    UIViewController *contentVC = (UIViewController *)content;
                    [contentVC beginAppearanceTransition:YES animated:NO];
                }
            }
        }
    }
}

- (void)contentDidAppear:(NSInteger)index {
    if (![self checkIndexValid:index]) {
        return;
    }
    self.currentIndex = index;
    id<BZMPageContentProtocol> content = _validContentDict[@(index)];
    if (content && [content respondsToSelector:@selector(contentDidAppear)]) {
        [content contentDidAppear];
    }
    if ([content isKindOfClass:[UIViewController class]]) {
        UIViewController *contentVC = (UIViewController *)content;
        [contentVC endAppearanceTransition];
    }
}

- (void)contentWillDisappear:(NSInteger)index {
    if (![self checkIndexValid:index]) {
        return;
    }
    id<BZMPageContentProtocol> content = _validContentDict[@(index)];
    if (content && [content respondsToSelector:@selector(contentWillDisappear)]) {
        [content contentWillDisappear];
    }
    if ([content isKindOfClass:[UIViewController class]]) {
        UIViewController *contentVC = (UIViewController *)content;
        [contentVC beginAppearanceTransition:NO animated:NO];
    }
}

- (void)contentDidDisappear:(NSInteger)index {
    if (![self checkIndexValid:index]) {
        return;
    }
    id<BZMPageContentProtocol> content = _validContentDict[@(index)];
    if (content && [content respondsToSelector:@selector(contentDidDisappear)]) {
        [content contentDidDisappear];
    }
    if ([content isKindOfClass:[UIViewController class]]) {
        UIViewController *contentVC = (UIViewController *)content;
        [contentVC endAppearanceTransition];
    }
}

- (BOOL)checkIndexValid:(NSInteger)index {
    NSUInteger count = [self.dataSource numberOfContentInContainerView:self];
    if (count <= 0 || index >= count) {
        return NO;
    }
    return YES;
}

@end

