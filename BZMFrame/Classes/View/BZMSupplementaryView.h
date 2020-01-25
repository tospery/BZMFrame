//
//  BZMSupplementaryView.h
//  Pods
//
//  Created by 杨建祥 on 2020/1/7.
//

#import <UIKit/UIKit.h>
#import "BZMSupplementary.h"
#import "BZMReactiveView.h"

@interface BZMSupplementaryView : UICollectionReusableView <BZMSupplementary, BZMReactiveView>
@property (nonatomic, strong, readonly) id viewModel;

- (void)didInitialize;

//+ (NSString *)kind;
//+ (NSString *)identifier;
//+ (CGSize)sizeForSection:(NSInteger)section;

@end

