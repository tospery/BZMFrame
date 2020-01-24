//
//  BZMPageContainerProtocol.h
//  Pods
//
//  Created by 杨建祥 on 2020/1/10.
//

#import <UIKit/UIKit.h>

@protocol BZMPageContainerProtocol <NSObject>
- (void)setDefaultSelectedIndex:(NSInteger)index;
- (UIScrollView *)contentScrollView;
- (void)reloadData;
- (void)scrollingFromLeftIndex:(NSInteger)leftIndex toRightIndex:(NSInteger)rightIndex ratio:(CGFloat)ratio selectedIndex:(NSInteger)selectedIndex;
- (void)didClickSelectedItemAtIndex:(NSInteger)index;

@end
