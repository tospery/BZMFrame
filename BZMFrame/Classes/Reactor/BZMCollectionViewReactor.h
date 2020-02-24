//
//  BZMCollectionViewReactor.h
//  Pods
//
//  Created by 杨建祥 on 2020/2/22.
//

#import "BZMScrollViewReactor.h"
#import "BZMCollectionReactor.h"

@class BZMCollectionViewReactor;

@protocol BZMCollectionViewReactorDataSource <BZMScrollViewReactorDataSource, UICollectionViewDataSource>
- (BZMCollectionReactor *)collectionViewReactor:(BZMCollectionViewReactor *)collectionViewReactor reactorAtIndexPath:(NSIndexPath *)indexPath;
- (Class)collectionViewReactor:(BZMCollectionViewReactor *)collectionViewReactor classForReactor:(BZMCollectionReactor *)reactor;

@end

@interface BZMCollectionViewReactor : BZMScrollViewReactor <BZMCollectionViewReactorDataSource>
@property (nonatomic, strong) NSDictionary *cellMapping;
@property (nonatomic, strong) NSArray *headerNames;
@property (nonatomic, strong) NSArray *footerNames;

- (void)configureCell:(UICollectionViewCell *)cell atIndexPath:(NSIndexPath *)indexPath withReactor:(BZMCollectionReactor *)reactor;
- (void)configureHeader:(UICollectionReusableView *)header atIndexPath:(NSIndexPath *)indexPath;
- (void)configureFooter:(UICollectionReusableView *)footer atIndexPath:(NSIndexPath *)indexPath;

@end

