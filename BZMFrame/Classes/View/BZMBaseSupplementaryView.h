//
//  BZMBaseSupplementaryView.h
//  Pods
//
//  Created by 杨建祥 on 2020/1/7.
//

#import <UIKit/UIKit.h>
#import "BZMReactiveView.h"
#import "BZMSupplementaryView.h"

@interface BZMBaseSupplementaryView : UICollectionReusableView <BZMSupplementaryView, BZMReactiveView>
@property (nonatomic, strong, readonly) id viewModel;

//- (void)didInitialize;

//+ (NSString *)kind;
//+ (NSString *)identifier;
//+ (CGSize)sizeForSection:(NSInteger)section;

@end

