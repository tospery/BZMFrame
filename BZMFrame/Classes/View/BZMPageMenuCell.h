//
//  BZMPageMenuCell.h
//  Pods
//
//  Created by 杨建祥 on 2020/1/10.
//

#import "BZMCollectionCell.h"
#import "BZMType.h"
#import "BZMPageMenuItem.h"
#import "BZMPageMenuAnimator.h"

@interface BZMPageMenuCell : BZMCollectionCell
@property (nonatomic, strong, readonly) BZMPageMenuItem *viewModel;
@property (nonatomic, strong, readonly) BZMPageMenuAnimator *animator;

- (void)didInitialize NS_REQUIRES_SUPER;
- (void)bindViewModel:(id)viewModel NS_REQUIRES_SUPER;
- (BOOL)checkCanStartSelectedAnimation:(BZMPageMenuItem *)item;
- (void)addSelectedAnimationBlock:(BZMPageMenuCellSelectedAnimationBlock)block;
- (void)startSelectedAnimationIfNeeded:(BZMPageMenuItem *)item;

@end
