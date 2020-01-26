//
//  BZMScrollViewController.h
//  Pods
//
//  Created by 杨建祥 on 2019/12/30.
//

#import "BZMBaseViewController.h"
#import "BZMScrollViewModel.h"

typedef NS_ENUM(NSInteger, BZMScrollDirection){
    BZMScrollDirectionNone,
    BZMScrollDirectionUp,
    BZMScrollDirectionDown
};

@interface BZMScrollViewController : BZMBaseViewController <BZMScrollViewModelDelegate, DZNEmptyDataSetDelegate, UIScrollViewDelegate>
@property (nonatomic, assign, readonly) CGFloat lastPosition;
@property (nonatomic, assign, readonly) BZMScrollDirection scrollDirection;
@property (nonatomic, strong) UIScrollView *scrollView;

- (void)setupRefresh:(BOOL)enable;
- (void)setupMore:(BOOL)enable;

- (void)beginRefresh;
- (void)triggerRefresh;
- (void)endRefresh;

- (void)beginMore;
- (void)triggerMore;
- (void)endMore;

@end

