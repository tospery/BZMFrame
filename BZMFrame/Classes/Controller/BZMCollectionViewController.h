//
//  BZMCollectionViewController.h
//  Pods
//
//  Created by 杨建祥 on 2019/12/30.
//

#import "BZMScrollViewController.h"
#import "BZMCollectionViewModel.h"

@interface BZMCollectionViewController : BZMScrollViewController <UICollectionViewDelegate, UICollectionViewDelegateFlowLayout>
@property (nonatomic, strong, readonly) UICollectionView *collectionView;

- (UICollectionViewLayout *)collectionViewLayout;

@end

