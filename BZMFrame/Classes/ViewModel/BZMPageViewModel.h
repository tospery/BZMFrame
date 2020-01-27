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

@interface BZMPageViewModel : BZMScrollViewModel <BZMPageViewModelDataSource>

@end

