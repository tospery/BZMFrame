//
//  BZMPageMenuCell.m
//  Pods
//
//  Created by 杨建祥 on 2020/1/10.
//

#import "BZMPageMenuCell.h"

@interface BZMPageMenuCell ()
@property (nonatomic, strong) BZMPageMenuItem *viewModel;
@property (nonatomic, strong) BZMPageMenuAnimator *animator;
@property (nonatomic, strong) NSMutableArray <BZMPageMenuCellSelectedAnimationBlock> *animationBlockArray;

@end

@implementation BZMPageMenuCell
@dynamic viewModel;

- (void)dealloc
{
    [self.animator stop];
}

- (void)prepareForReuse {
    [super prepareForReuse];

    [self.animator stop];
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self didInitialize];
    }
    return self;
}

- (void)didInitialize {
    _animationBlockArray = [NSMutableArray array];
}

- (void)bindViewModel:(BZMPageMenuItem *)item {
    self.viewModel = item;
    if (item.isSelectedAnimationEnabled) {
        [self.animationBlockArray removeLastObject];
        if ([self checkCanStartSelectedAnimation:item]) {
            _animator = [[BZMPageMenuAnimator alloc] init];
            self.animator.duration = item.selectedAnimationDuration;
        }else {
            [self.animator stop];
        }
    }
}

- (BOOL)checkCanStartSelectedAnimation:(BZMPageMenuItem *)item {
    if (item.selectedType == BZMPageMenuCellSelectedTypeCode || item.selectedType == BZMPageMenuCellSelectedTypeClick) {
        return YES;
    }
    return NO;
}

- (void)addSelectedAnimationBlock:(BZMPageMenuCellSelectedAnimationBlock)block {
    [self.animationBlockArray addObject:block];
}

- (void)startSelectedAnimationIfNeeded:(BZMPageMenuItem *)item {
    if (item.isSelectedAnimationEnabled && [self checkCanStartSelectedAnimation:item]) {
        //需要更新isTransitionAnimating，用于处理在过滤时，禁止响应点击，避免界面异常。
        item.transitionAnimating = YES;
        __weak typeof(self)weakSelf = self;
        self.animator.progressCallback = ^(CGFloat percent) {
            for (BZMPageMenuCellSelectedAnimationBlock block in weakSelf.animationBlockArray) {
                block(percent);
            }
        };
        self.animator.completeCallback = ^{
            item.transitionAnimating = NO;
            [weakSelf.animationBlockArray removeAllObjects];
        };
        [self.animator start];
    }
}

@end

