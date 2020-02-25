//
//  BZMScrollViewReactor.h
//  Pods
//
//  Created by 杨建祥 on 2020/2/22.
//

#import "BZMViewReactor.h"
#import <DZNEmptyDataSet/UIScrollView+EmptyDataSet.h>
#import "BZMPage.h"

@class BZMScrollViewReactor;

@protocol BZMScrollViewReactorDataSource <BZMViewReactorDataSource, DZNEmptyDataSetSource>

@end

@interface BZMScrollViewReactor : BZMViewReactor <BZMScrollViewReactorDataSource>
@property (nonatomic, assign) BOOL shouldPullToRefresh;
@property (nonatomic, assign) BOOL shouldScrollToMore;
@property (nonatomic, assign) BOOL hasMoreData;
@property (nonatomic, strong, readonly) BZMPage *page;
@property (nonatomic, strong, readonly) RACCommand *selectCommand;

- (NSInteger)offsetForPage:(NSInteger)page;
- (NSInteger)nextPageIndex;

@end

