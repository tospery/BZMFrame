//
//  BZMCollectionViewModel.m
//  ReactHub
//
//  Created by 杨建祥 on 2019/12/29.
//  Copyright © 2019 杨建祥. All rights reserved.
//

#import "BZMCollectionViewModel.h"
#import <QMUIKit/QMUIKit.h>
#import "BZMSupplementaryView.h"
#import "BZMCollectionCell.h"
#import "NSArray+BZMFrame.h"
#import "NSDictionary+BZMFrame.h"
#import "NSError+BZMFrame.h"
#import "UICollectionReusableView+BZMFrame.h"

@interface BZMCollectionViewModel ()

@end

@implementation BZMCollectionViewModel

#pragma mark - Init
- (instancetype)initWithRouteParameters:(NSDictionary<NSString *,id> *)parameters {
    if (self = [super initWithRouteParameters:parameters]) {
        //self.canSelectCell = YES;
    }
    return self;
}

- (void)didInitialize {
    [super didInitialize];
}

#pragma mark - View
#pragma mark - Property
#pragma mark - Method
- (NSArray *)data2Source:(id)data {
    if (!data || ![data isKindOfClass:NSArray.class]) {
        return nil;
    }
    NSArray *items = (NSArray *)data;
    if (items.count == 0) {
        self.error = [NSError bzm_errorWithCode:BZMErrorCodeEmpty];
        return nil;
    }
    return @[items];
}

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
    SEL sel = @selector(bzm_reuseId);
    NSString *reuseId = nil;
    if ([cls respondsToSelector:sel]) {
        reuseId = ((id (*)(id, SEL))[cls methodForSelector:sel])(cls, sel);
    }
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseId forIndexPath:indexPath];
    [self configureCell:cell atIndexPath:indexPath withItem:item];
    if ([cell conformsToProtocol:@protocol(BZMReactiveView)]) {
        id<BZMReactiveView> reactiveView = (id<BZMReactiveView>)cell;
        [reactiveView bindViewModel:item];
    }
    
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
    NSInteger index = self.headerNames.count;
    NSMutableArray *names = [NSMutableArray arrayWithArray:self.headerNames];
    [names addObjectsFromArray:self.footerNames];
    
    for (NSInteger i = 0; i < names.count; ++i) {
        Class cls = NSClassFromString(names[i]);
        if ([cls conformsToProtocol:@protocol(BZMSupplementaryView)]) {
            id<BZMSupplementaryView> supplementary = (id<BZMSupplementaryView>)cls;
            if ([kind isEqualToString:[supplementary kind]]) {
                SEL sel = @selector(bzm_reuseId);
                if ([cls respondsToSelector:sel]) {
                    NSString *reuseId = ((id (*)(id, SEL))[cls methodForSelector:sel])(cls, sel);
                    if (reuseId && [reuseId isKindOfClass:NSString.class] && reuseId.length != 0) {
                        view = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:reuseId forIndexPath:indexPath];
                        if (view) {
                            isHeader = (i < index);
                            break;
                        }
                    }
                }
            }
        }
    }
    
    if (view) {
        if (isHeader) {
            [self configureHeader:view atIndexPath:indexPath];
        }else {
            [self configureFooter:view atIndexPath:indexPath];
        }
    }
    
    return view;
}

#pragma mark - Class


@end
