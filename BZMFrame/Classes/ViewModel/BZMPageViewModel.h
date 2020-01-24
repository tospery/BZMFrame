//
//  BZMPageViewModel.h
//  Pods
//
//  Created by 杨建祥 on 2020/1/10.
//

#import "BZMScrollViewModel.h"
#import "BZMPageContainerView.h"

@class BZMPageViewModel;

@protocol BZMPageViewModelDataSource <BZMScrollViewModelDataSource, BZMPageContainerViewDataSource>

@end

@protocol BZMPageViewModelDelegate <BZMScrollViewModelDelegate>

@end

@interface BZMPageViewModel : BZMScrollViewModel <BZMPageViewModelDataSource>
@property (nonatomic, weak) id<BZMPageViewModelDelegate> delegate;

@end

