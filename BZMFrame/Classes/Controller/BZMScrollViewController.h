//
//  BZMScrollViewController.h
//  Pods
//
//  Created by 杨建祥 on 2020/2/22.
//

#import "BZMViewController.h"
#import "BZMScrollViewReactor.h"

typedef NS_ENUM(NSInteger, BZMScrollDirection){
    BZMScrollDirectionNone,
    BZMScrollDirectionUp,
    BZMScrollDirectionDown
};

@interface BZMScrollViewController : BZMViewController <UIScrollViewDelegate, DZNEmptyDataSetDelegate>
@property (nonatomic, assign, readonly) CGFloat lastPosition;
@property (nonatomic, assign, readonly) BZMScrollDirection scrollDirection;
@property (nonatomic, strong) UIScrollView *scrollView;

//- (void)reloadItemsAtIndexPaths:(NSArray *)indexPaths;
//- (void)preloadNextPage;
//

- (void)setupRefresh:(BOOL)enable;
- (void)beginRefresh;
- (void)triggerRefresh;
- (void)endRefresh;

- (void)setupMore:(BOOL)enable;
- (void)beginMore;
- (void)triggerMore;
- (void)endMore;

@end

