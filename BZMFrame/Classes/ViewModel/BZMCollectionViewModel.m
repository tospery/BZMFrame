//
//  BZMCollectionViewModel.m
//  ReactHub
//
//  Created by 杨建祥 on 2019/12/29.
//  Copyright © 2019 杨建祥. All rights reserved.
//

#import "BZMCollectionViewModel.h"
#import <QMUIKit/QMUIKit.h>
#import "BZMCollectionCell.h"
#import "NSArray+BZMFrame.h"
#import "NSDictionary+BZMFrame.h"

@interface BZMCollectionViewModel ()

@end

@implementation BZMCollectionViewModel
@dynamic delegate;

#pragma mark - Init
- (instancetype)initWithRouteParameters:(NSDictionary<NSString *,id> *)parameters {
    if (self = [super initWithRouteParameters:parameters]) {
        self.canSelectCell = YES;
    }
    return self;
}

- (void)didInitialize {
    [super didInitialize];
}

#pragma mark - View
#pragma mark - Property
#pragma mark - Method
#pragma mark super
//- (BOOL (^)(NSError *error))requestRemoteDataErrorsFilter {
//    return ^(NSError *error) {
//        switch (self.requestMode) {
//            case TBRequestModeMore: {
//                if (TBErrorCodeAppDataEmpty != error.code) {
//                    // [self.preloadPages removeObject:@([self nextPageIndex])];
//                }
//                break;
//            }
//            default:
//                break;
//        }
//        return YES;
//    };
//}

#pragma mark public
- (void)configureCell:(UICollectionViewCell *)cell atIndexPath:(NSIndexPath *)indexPath withItem:(BZMCollectionItem *)item {
    
}

- (void)configureHeader:(UICollectionReusableView *)header atIndexPath:(NSIndexPath *)indexPath {
    
}

- (void)configureFooter:(UICollectionReusableView *)footer atIndexPath:(NSIndexPath *)indexPath {
    
}

#pragma mark private
#pragma mark - Delegate
#pragma mark BZMCollectionViewModelDataSource
- (BZMCollectionItem *)collectionViewModel:(BZMCollectionViewModel *)viewModel itemAtIndexPath:(NSIndexPath *)indexPath {
    return self.dataSource[indexPath.section][indexPath.row];
}

- (Class)collectionViewModel:(BZMCollectionViewModel *)viewModel cellClassForItem:(BZMCollectionItem *)item {
    NSString *name = [self.itemCellMapping objectForKey:NSStringFromClass(item.class)];
    return NSClassFromString(name);
}

//- (Class)collectionViewModel:(BZMCollectionViewModel *)viewModel headerClassOfKind:(NSString *)kind atSection:(NSInteger)section {
//    NSArray *names = [self.headerClassMapping bzm_arrayForKey:kind];
//    NSString *name = [names bzm_objectAtIndex:section];
//    return NSClassFromString(name);
//}
//
//- (Class)collectionViewModel:(BZMCollectionViewModel *)viewModel footerClassOfKind:(NSString *)kind atSection:(NSInteger)section {
//    NSArray *names = [self.footerClassMapping bzm_arrayForKey:kind];
//    NSString *name = [names bzm_objectAtIndex:section];
//    return NSClassFromString(name);
//}

#pragma mark UICollectionViewDataSource
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return self.dataSource.count;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return [(NSArray *)self.dataSource[section] count];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    BZMCollectionItem *item = [self collectionViewModel:self itemAtIndexPath:indexPath];
    Class cls = [self collectionViewModel:self cellClassForItem:item];
    NSString *identifier = [cls identifier];
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:indexPath];
    if ([cell isKindOfClass:BZMCollectionCell.class]) {
        [(BZMCollectionCell *)cell bindViewModel:item];
    }
    [self configureCell:cell atIndexPath:indexPath withItem:item];
    
//    NSArray *items = (NSArray *)self.dataSource.lastObject;
//    if (self.shouldScrollToMore &&
//        (items.count - indexPath.row) < self.pageSize &&
//        ![self.preloadPages containsObject:@(items.count)]) {
//        [self.preloadPages addObject:@(items.count)];
//        [self.delegate preloadNextPage];
//    }
    
    return cell;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    UICollectionReusableView *view = nil;
    
    BOOL isHeader = YES;
    Class cls = nil;
    SEL sel = NSSelectorFromString(@"kind");
    
    for (NSString *name in self.headerNames) {
        cls = NSClassFromString(name);
        if (cls && [cls respondsToSelector:sel]) {
            NSString *myKind = ((NSString *(*)(id, SEL))[cls methodForSelector:sel])(cls, sel);
            if ([myKind isEqualToString:kind]) {
                isHeader = YES;
                break;
            }
        }
        cls = nil;
    }
    if (!cls) {
        for (NSString *name in self.footerNames) {
            cls = NSClassFromString(name);
            if (cls && [cls respondsToSelector:sel]) {
                NSString *myKind = ((NSString *(*)(id, SEL))[cls methodForSelector:sel])(cls, sel);
                if ([myKind isEqualToString:kind]) {
                    isHeader = NO;
                    break;
                }
            }
        }
        cls = nil;
    }
    
    sel = NSSelectorFromString(@"identifier");
    if (cls && [cls respondsToSelector:sel]) {
        NSString *myIdentifier = ((NSString *(*)(id, SEL))[cls methodForSelector:sel])(cls, sel);
        if (myIdentifier.length != 0) {
            view = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:myIdentifier forIndexPath:indexPath];
            if (isHeader) {
                [self configureHeader:view atIndexPath:indexPath];
            }else {
                [self configureFooter:view atIndexPath:indexPath];
            }
        }
    }
    
    return view;
}

#pragma mark - Class


@end
