//
//  BZMWaterfallViewController.m
//  Pods
//
//  Created by 杨建祥 on 2020/1/25.
//

#import "BZMWaterfallViewController.h"
#import "BZMConst.h"
#import "BZMFunction.h"
#import "BZMCollectionCell.h"
#import "BZMSupplementaryView.h"
#import "UIViewController+BZMFrame.h"

@interface BZMWaterfallViewController ()
@property (nonatomic, strong, readwrite) BZMWaterfallViewModel *viewModel;

@end

@implementation BZMWaterfallViewController
@dynamic viewModel;

#pragma mark - Init
- (instancetype)initWithViewModel:(BZMWaterfallViewModel *)viewModel {
    if (self = [super initWithViewModel:viewModel]) {
    }
    return self;
}

- (void)dealloc {
    
}

#pragma mark - View
- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
}

#pragma mark - Property

#pragma mark - Method
- (UICollectionViewLayout *)collectionViewLayout {
    return [[CHTCollectionViewWaterfallLayout alloc] init];
}

#pragma mark - Delegate
#pragma mark CHTCollectionViewDelegateWaterfallLayout
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout heightForHeaderInSection:(NSInteger)section {
    return [self collectionView:collectionView layout:collectionViewLayout referenceSizeForHeaderInSection:section].height;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout heightForFooterInSection:(NSInteger)section {
    return [self collectionView:collectionView layout:collectionViewLayout referenceSizeForFooterInSection:section].height;
}

// 行间距
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    return [self collectionView:collectionView layout:collectionViewLayout minimumLineSpacingForSectionAtIndex:section];
}

// 列间距
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumColumnSpacingForSectionAtIndex:(NSInteger)section {
    return [super collectionView:collectionView layout:collectionViewLayout minimumInteritemSpacingForSectionAtIndex:section];
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForHeaderInSection:(NSInteger)section {
    return UIEdgeInsetsZero;
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForFooterInSection:(NSInteger)section {
    return UIEdgeInsetsZero;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout columnCountForSection:(NSInteger)section {
    return 1;
}

@end
