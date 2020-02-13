//
//  BZMScrollViewModel.h
//  ReactHub
//
//  Created by 杨建祥 on 2019/12/29.
//  Copyright © 2019 杨建祥. All rights reserved.
//

#import "BZMBaseViewModel.h"
#import <DZNEmptyDataSet/UIScrollView+EmptyDataSet.h>
#import "BZMPage.h"

@class BZMScrollViewModel;

@protocol BZMScrollViewModelDataSource <BZMBaseViewModelDataSource, DZNEmptyDataSetSource>

@end

@interface BZMScrollViewModel : BZMBaseViewModel <BZMScrollViewModelDataSource>
@property (nonatomic, assign) BOOL shouldPullToRefresh;
@property (nonatomic, assign) BOOL shouldScrollToMore;
@property (nonatomic, assign) BOOL hasMoreData;
@property (nonatomic, strong) BZMPage *page;
@property (nonatomic, strong) NSMutableArray *preloadPages;
@property (nonatomic, strong, readonly) RACCommand *selectCommand;

- (NSUInteger)offsetForPage:(NSUInteger)page;
- (NSInteger)nextPageIndex;

@end

