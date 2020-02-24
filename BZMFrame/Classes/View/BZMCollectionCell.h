//
//  BZMCollectionCell.h
//  Pods
//
//  Created by 杨建祥 on 2020/2/22.
//

#import <UIKit/UIKit.h>
#import "BZMReactive.h"
#import "BZMCollectionReactor.h"

@interface BZMCollectionCell : UICollectionViewCell <BZMReactive>
@property (nonatomic, strong, readonly) BZMCollectionReactor *reactor;

@end

