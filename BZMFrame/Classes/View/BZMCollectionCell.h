//
//  BZMCollectionCell.h
//  Pods
//
//  Created by 杨建祥 on 2020/1/7.
//

#import <UIKit/UIKit.h>
#import <QMUIKit/QMUIKit.h>
#import "BZMReactiveView.h"
#import "BZMCollectionItem.h"

@interface BZMCollectionCell : UICollectionViewCell <BZMReactiveView>
@property (nonatomic, strong, readonly) BZMCollectionItem *viewModel;

+ (NSString *)identifier;

@end

