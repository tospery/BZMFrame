//
//  BZMCollectionViewController.m
//  Pods
//
//  Created by 杨建祥 on 2020/2/22.
//

#import "BZMCollectionViewController.h"
#import <DKNightVersion/DKNightVersion.h>
#import "BZMConstant.h"
#import "BZMFunction.h"
#import "BZMCollectionCell.h"
#import "BZMSupplementaryView.h"
#import "BZMCollectionViewReactor.h"
#import "UICollectionReusableView+BZMFrame.h"

@interface BZMCollectionViewController ()
@property (nonatomic, strong, readwrite) UICollectionView *collectionView;
@property (nonatomic, strong, readwrite) BZMCollectionViewReactor *reactor;

@end

@implementation BZMCollectionViewController
@dynamic reactor;

#pragma mark - Init
- (instancetype)initWithReactor:(BZMViewReactor *)reactor {
    if (self = [super initWithReactor:reactor]) {
    }
    return self;
}

- (void)dealloc {
    _collectionView.dataSource = nil;
    _collectionView.delegate = nil;
    _collectionView.emptyDataSetSource = nil;
    _collectionView.emptyDataSetDelegate = nil;
    _collectionView = nil;
}

#pragma mark - View
- (void)viewDidLoad {
    [super viewDidLoad];
    
    UICollectionView *collectionView = [[UICollectionView alloc] initWithFrame:self.contentFrame collectionViewLayout:[self collectionViewLayout]];
    collectionView.dataSource = self.reactor;
    collectionView.delegate = self;
    collectionView.emptyDataSetSource = self.reactor;
    collectionView.emptyDataSetDelegate = self;
    collectionView.dk_backgroundColorPicker = DKColorPickerWithKey(BG);
    if (@available(iOS 11.0, *)) {
        collectionView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    }
    [self.view addSubview:collectionView];
    self.collectionView = collectionView;
    
    [self.collectionView registerClass:UICollectionViewCell.class forCellWithReuseIdentifier:kBZMIdentifierCollectionCell];
    [self.collectionView registerClass:BZMCollectionCell.class forCellWithReuseIdentifier:BZMCollectionCell.bzm_reuseId];
    [self.collectionView registerClass:UICollectionReusableView.class forSupplementaryViewOfKind:UICollectionElementKindSectionHeader  withReuseIdentifier:kBZMIdentifierCollectionHeader];
    [self.collectionView registerClass:UICollectionReusableView.class forSupplementaryViewOfKind:UICollectionElementKindSectionFooter  withReuseIdentifier:kBZMIdentifierCollectionFooter];
    
    SEL reuseSel = @selector(bzm_reuseId);
    
    // cell
    {
        NSArray *reactorNames = self.reactor.cellMapping.allKeys;
        for (NSString *reactorName in reactorNames) {
            Class reactorCls = NSClassFromString(reactorName);
            if (!reactorCls) {
                continue;
            }
            
            NSString *cellName = self.reactor.cellMapping[reactorName];
            if (cellName.length == 0) {
                continue;
            }
            
            Class cellCls = NSClassFromString(cellName);
            if (!cellCls) {
                continue;
            }
            
            if (![cellCls respondsToSelector:reuseSel]) {
                continue;
            }
            
            NSString *reuseId = ((id (*)(id, SEL))[cellCls methodForSelector:reuseSel])(cellCls, reuseSel);
            if (!reuseId || ![reuseId isKindOfClass:NSString.class] || reuseId.length == 0) {
                continue;
            }
            
            NSString *cellPath = [NSBundle.mainBundle pathForResource:cellName ofType:@"nib"];
            if (cellPath.length == 0) {
                [self.collectionView registerClass:cellCls forCellWithReuseIdentifier:reuseId];
            }else {
                UINib *cellNib = [UINib nibWithNibName:cellName bundle:nil];
                [self.collectionView registerNib:cellNib forCellWithReuseIdentifier:reuseId];
            }
        }
    }
    
    // header/footer
    {
        NSMutableArray *names = [NSMutableArray arrayWithArray:self.reactor.headerNames];
        [names addObjectsFromArray:self.reactor.footerNames];
        for (NSString *name in names) {
            Class cls = NSClassFromString(name);
            if ([cls conformsToProtocol:@protocol(BZMSupplementary)] && [cls respondsToSelector:reuseSel]) {
                id<BZMSupplementary> supplementary = (id<BZMSupplementary>)cls;
                NSString *kind = [supplementary kind];
                NSString *reuse = ((id (*)(id, SEL))[cls methodForSelector:reuseSel])(cls, reuseSel);
                if ((kind && [kind isKindOfClass:NSString.class] && kind.length != 0) &&
                    (reuse && [reuse isKindOfClass:NSString.class] && reuse.length != 0)) {
                    [self.collectionView registerClass:cls forSupplementaryViewOfKind:kind withReuseIdentifier:reuse];
                }
            }
        }
    }
}

#pragma mark - Property
- (void)setCollectionView:(UICollectionView *)collectionView {
    _collectionView = collectionView;
    self.scrollView = collectionView;
}

#pragma mark - Layout
- (UICollectionViewLayout *)collectionViewLayout {
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.scrollDirection = UICollectionViewScrollDirectionVertical;
    layout.minimumLineSpacing = 0.0f;
    layout.minimumInteritemSpacing = 0.0f;
    layout.sectionInset = UIEdgeInsetsZero;
    return layout;
}

#pragma mark - Data
- (void)reloadData {
    [super reloadData];
    [self.collectionView reloadData];
}

#pragma mark - Delegate
#pragma mark UICollectionViewDelegateFlowLayout
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    if (![collectionView.dataSource conformsToProtocol:@protocol(BZMCollectionViewReactorDataSource)]) {
        return CGSizeZero;
    }
    id<BZMCollectionViewReactorDataSource> dataSource = (id<BZMCollectionViewReactorDataSource>)collectionView.dataSource;
    BZMCollectionReactor *reactor = [dataSource collectionViewReactor:self.reactor reactorAtIndexPath:indexPath];
    return reactor.cellSize;
}

/// 内边距
//- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
//    return UIEdgeInsetsZero;
//}

/// 行间距
//- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
//    return 0.0f;
//}
//
/// 列间距
//- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
//    return 0.0f;
//}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section {
    return CGSizeZero;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section {
    return CGSizeZero;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    [collectionView deselectItemAtIndexPath:indexPath animated:YES];
    if (![collectionView.dataSource conformsToProtocol:@protocol(BZMCollectionViewReactorDataSource)]) {
        return;
    }
    id<BZMCollectionViewReactorDataSource> dataSource = (id<BZMCollectionViewReactorDataSource>)collectionView.dataSource;
    BZMCollectionReactor *reactor = [dataSource collectionViewReactor:self.reactor reactorAtIndexPath:indexPath];
    [self.reactor.selectCommand execute:RACTuplePack(indexPath, reactor)];
}

@end
