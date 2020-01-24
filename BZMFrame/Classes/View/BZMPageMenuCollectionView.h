//
//  BZMPageMenuCollectionView.h
//  Pods
//
//  Created by 杨建祥 on 2020/1/10.
//

#import <UIKit/UIKit.h>
#import "BZMPageMenuIndicator.h"

@class BZMPageMenuCollectionView;

@protocol BZMPageMenuCollectionViewGesture <NSObject>
@optional
- (BOOL)collectionView:(BZMPageMenuCollectionView *)collectionView gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer;
- (BOOL)collectionView:(BZMPageMenuCollectionView *)collectionView gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer;

@end

@interface BZMPageMenuCollectionView : UICollectionView
@property (nonatomic, strong) NSArray <UIView<BZMPageMenuIndicator> *> *indicators;
@property (nonatomic, weak) id<BZMPageMenuCollectionViewGesture> gesture;

@end

