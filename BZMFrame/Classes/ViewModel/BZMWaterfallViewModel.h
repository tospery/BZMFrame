//
//  BZMWaterfallViewModel.h
//  Pods
//
//  Created by 杨建祥 on 2020/1/25.
//

#import "BZMCollectionViewModel.h"
#import <CHTCollectionViewWaterfallLayout/CHTCollectionViewWaterfallLayout.h>

@class BZMWaterfallViewModel;

@protocol BZMWaterfallViewModelDataSource <BZMCollectionViewModelDataSource>

@end

//@protocol BZMWaterfallViewModelDelegate <BZMCollectionViewModelDelegate>
//
//@end

@interface BZMWaterfallViewModel : BZMCollectionViewModel <BZMWaterfallViewModelDataSource>
//@property (nonatomic, weak) id<BZMWaterfallViewModelDelegate> delegate;

@end

