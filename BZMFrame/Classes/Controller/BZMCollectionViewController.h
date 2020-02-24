//
//  BZMCollectionViewController.h
//  Pods
//
//  Created by 杨建祥 on 2020/2/22.
//

#import "BZMScrollViewController.h"

@interface BZMCollectionViewController : BZMScrollViewController <UICollectionViewDelegate, UICollectionViewDelegateFlowLayout>
@property (nonatomic, strong, readonly) UICollectionView *collectionView;

- (UICollectionViewLayout *)collectionViewLayout;

@end

