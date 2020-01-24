//
//  BZMPageViewModel.m
//  Pods
//
//  Created by 杨建祥 on 2020/1/10.
//

#import "BZMPageViewModel.h"

@interface BZMPageViewModel ()

@end

@implementation BZMPageViewModel
@dynamic delegate;

#pragma mark - Init
#pragma mark - View
#pragma mark - Property
#pragma mark - Method
#pragma mark super
#pragma mark public
#pragma mark private

#pragma mark - Delegate
#pragma mark BZMPageContainerViewDataSource
- (NSInteger)numberOfContentInContainerView:(BZMPageContainerView *)containerView {
    return self.dataSource.count;
}

- (id<BZMPageContentProtocol>)containerView:(BZMPageContainerView *)containerView initContentForIndex:(NSInteger)index {
    return nil;
}

#pragma mark - Class

@end
