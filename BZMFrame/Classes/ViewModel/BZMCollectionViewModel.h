//
//  BZMCollectionViewModel.h
//  ReactHub
//
//  Created by 杨建祥 on 2019/12/29.
//  Copyright © 2019 杨建祥. All rights reserved.
//

#import "BZMScrollViewModel.h"
#import "BZMCollectionItem.h"

@class BZMCollectionViewModel;

@protocol BZMCollectionViewModelDataSource <BZMScrollViewModelDataSource, UICollectionViewDataSource>
- (BZMCollectionItem *)collectionViewModel:(BZMCollectionViewModel *)viewModel itemAtIndexPath:(NSIndexPath *)indexPath;
- (Class)collectionViewModel:(BZMCollectionViewModel *)viewModel cellClassForItem:(BZMCollectionItem *)item;
//- (Class)collectionViewModel:(BZMCollectionViewModel *)viewModel headerClassOfKind:(NSString *)kind atSection:(NSInteger)section;
//- (Class)collectionViewModel:(BZMCollectionViewModel *)viewModel footerClassOfKind:(NSString *)kind atSection:(NSInteger)section;

@end

//@protocol BZMCollectionViewModelDelegate <BZMScrollViewModelDelegate>
//
//@end

@interface BZMCollectionViewModel : BZMScrollViewModel <BZMCollectionViewModelDataSource>
@property (nonatomic, assign) BOOL canSelectCell;
@property (nonatomic, strong) NSDictionary *itemCellMapping;
// @property (nonatomic, strong) NSDictionary *headerClassMapping;
@property (nonatomic, strong) NSArray *headerNames;
@property (nonatomic, strong) NSArray *footerNames;
//@property (nonatomic, strong) NSDictionary *footerClassMapping;

//@property (nonatomic, strong) id headerVM;
//@property (nonatomic, strong) id footerVM;

- (void)configureCell:(UICollectionViewCell *)cell atIndexPath:(NSIndexPath *)indexPath withItem:(BZMCollectionItem *)item;
- (void)configureHeader:(UICollectionReusableView *)header atIndexPath:(NSIndexPath *)indexPath;
- (void)configureFooter:(UICollectionReusableView *)footer atIndexPath:(NSIndexPath *)indexPath;

@end

